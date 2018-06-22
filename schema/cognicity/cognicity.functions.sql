
-- Create Trigger Function to update a report with instance region and local area id
CREATE OR REPLACE FUNCTION cognicity.define_report_region()
  RETURNS trigger AS
$BODY$
	BEGIN
	UPDATE cognicity.all_reports
    SET tags = (SELECT (la.x->0)::jsonb || (code.x->0)::jsonb FROM (SELECT COALESCE(array_to_json(array_agg(row_to_json(a))),'[{"local_area_id":null, "district_id":null}]') as x FROM (SELECT pkey::varchar as local_area_id, attributes->>'district_id' as district_id FROM cognicity.local_areas as j WHERE ST_Within(NEW.the_geom, j.the_geom)) as a) as la, (SELECT COALESCE(array_to_json(array_agg(row_to_json(a))),'[{"instance_region_code":null}]') as x FROM (SELECT code as instance_region_code FROM cognicity.instance_regions as i WHERE ST_Within(NEW.the_geom, i.the_geom)) as a) as code)
    WHERE pkey = NEW.pkey;
	RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER update_all_reports_with_region
  AFTER INSERT ON cognicity.all_reports
  FOR EACH ROW
  EXECUTE PROCEDURE cognicity.define_report_region();

-- Function: cognicity.rem_get_max_flood(start_timestamp, end_timestamp)
-- Function to get maximum flood state from all areas between a given start and end time
-- Start and end times shouldbe ISO8601 format and must include timezone as UTC offset e.g. 2017-01-01T13:00+0700
-- Returns a list of flood affected areas and their maximum flood state during given period.

-- Type for storing output
CREATE TYPE max_flood_type AS (local_area bigint, max_state int, changed timestamp with time zone, status_change_id bigint);

CREATE OR REPLACE FUNCTION cognicity.rem_get_max_flood(timestamp with time zone, timestamp with time zone)
  RETURNS SETOF max_flood_type
   AS
	$BODY$
		DECLARE
			-- internal variables
			start_date ALIAS FOR $1;
			end_date ALIAS FOR $2;
			output max_flood_type;  -- output with custom data type
			flood_record RECORD;	-- for listing of states
			local_area bigint;	-- current area
		BEGIN
			-- loop each area
			FOR local_area IN EXECUTE 'SELECT pkey FROM cognicity.local_areas' LOOP
				-- reset storage
				output.local_area = NULL;
				output.max_state  = 0;
				output.changed = NULL;
				output.status_change_id = NULL;

				-- loop flood record, for each area, up until specified end time
				FOR flood_record IN EXECUTE 'SELECT local_area, id, COALESCE(state, 0) as state, changed  FROM cognicity.rem_status_log WHERE local_area = '||local_area||' AND changed < '||quote_literal(end_date)||' ORDER BY changed' LOOP
					-- track the areas's flood state through the timeseries
					IF (flood_record.changed < start_date) THEN
						output.local_area:= local_area;
						output.max_state:= flood_record.state;
						output.changed:= flood_record.changed;
						output.status_change_id:= flood_record.id;
					-- inside the time window, test for maximum state value
					ELSEIF (output.max_state < flood_record.state) THEN
						output.local_area:= local_area;
						output.max_state:= flood_record.state;
						output.changed:= flood_record.changed;
						output.status_change_id:= flood_record.id;
					END IF;
				END LOOP;
				-- only return areas that were flooded
				IF (output.max_state > 0) THEN
					RETURN NEXT output;
				END IF;

			END LOOP;
		RETURN;
	END;

	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION cognicity.rem_get_max_flood(timestamp with time zone, timestamp with time zone)
  OWNER TO postgres;

-- Function: cognicity.rem_get_flood(timestamp)
-- Function to get flood state from all areas at a given time
-- Times shouldbe ISO8601 format and must include timezone as UTC offset e.g. 2017-01-01T13:00+0700
-- Returns a list of flood affected areas and their flood state at given point in time.
CREATE OR REPLACE FUNCTION cognicity.rem_get_flood(timestamp with time zone)
	RETURNS TABLE (	local_area bigint,
			changed timestamp with time zone,
			state integer,
			state_change_id bigint )
	AS
		$BODY$
			DECLARE
				query_time ALIAS FOR $1;
			BEGIN
				RETURN QUERY SELECT i.local_area, i.changed, i.state, i.id as state_change_id
				FROM (
					SELECT DISTINCT ON (j.local_area) j.local_area, j.changed, j.state, j.id
					FROM cognicity.rem_status_log as j
					WHERE j.changed <= query_time
					ORDER BY j.local_area, j.changed DESC
				) as i
				WHERE i.state > 0;
			END
		$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION cognicity.rem_get_flood(timestamp with time zone)
  OWNER TO postgres;

/* Output schema version */
CREATE FUNCTION cognicity.version()
  RETURNS varchar
  AS $BODY$
  BEGIN
  RETURN '3.1.0';
  END
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
