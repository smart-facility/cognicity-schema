-- Need to add properties push to all_reports e.g. flood heights.

-- Push grasp reports to CogniCity all reports
CREATE OR REPLACE FUNCTION grasp.update_all_reports_from_grasp()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
      UPDATE cognicity.all_reports SET image_url = NEW.image_url WHERE fkey = NEW.pkey AND source = 'grasp';
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION grasp.update_all_reports_from_grasp()
  OWNER TO postgres

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports_from_grasp
  BEFORE UPDATE
  ON grasp.reports
  FOR EACH ROW
EXECUTE PROCEDURE grasp.update_all_reports_from_grasp();

-- Push a grasp card report to all_reports. Requires card_id UUID.
CREATE OR REPLACE FUNCTION grasp.push_to_all_reports(varchar)
  RETURNS varchar AS $$
      DECLARE
        -- internal variables
        cardId ALIAS FOR $1; -- the report in grasp.reports
        reportId BIGINT;
        reportArea VARCHAR;
      BEGIN
        INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, report_data, the_geom, image_url)
          SELECT reports.pkey, reports.created_at, reports.text, 'grasp', reports.disaster_type, cards.language, cards.card_id, reports.card_data, reports.the_geom, reports.image_url
          FROM grasp.cards AS cards, grasp.reports AS reports WHERE cards.card_id = cardId::uuid AND reports.card_id = cardId::uuid
          RETURNING pkey INTO reportId;

          SELECT tags->>'instance_region_code' INTO reportArea FROM cognicity.all_reports WHERE pkey = reportId;

      RETURN ('{"reportId":' || reportId || ', "reportArea":'''|| reportArea ||'''}');
  END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION grasp.push_to_all_reports(varchar)
  OWNER TO postgres
