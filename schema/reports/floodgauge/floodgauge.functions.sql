-- Create Trigger Function to update a report with instance region and local area id
CREATE OR REPLACE FUNCTION floodgauge.define_report_region()
  RETURNS trigger AS
$BODY$
	BEGIN
	UPDATE floodgauge.reports
        SET tags = ('{"instance_region_code":"' || (SELECT code FROM cognicity.instance_regions AS i WHERE ST_WITHIN(NEW.the_geom, i.the_geom)) || '","local_area_id":"' || (SELECT pkey FROM cognicity.local_areas AS l WHERE ST_WITHIN(NEW.the_geom, l.the_geom))  || '"}')::json
        WHERE pkey = NEW.pkey;
	RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER update_floodgauge_reports_with_region
  AFTER INSERT ON floodgauge.reports
  FOR EACH ROW
  EXECUTE PROCEDURE floodgauge.define_report_region();
