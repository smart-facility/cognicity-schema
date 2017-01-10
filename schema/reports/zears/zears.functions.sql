-- Create Trigger Function to update all_reports table
CREATE OR REPLACE FUNCTION zears.update_all_reports()
  RETURNS trigger AS
$BODY$
	BEGIN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, image_url, report_data, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'zears', NEW.disaster_type, NEW.lang, NEW.url, NEW.image_url, NEW.report_data, NEW.the_geom;
			RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zears.update_all_reports()
  OWNER TO postgres;

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports_from_zears
  BEFORE INSERT
  ON zears.reports
  FOR EACH ROW
  EXECUTE PROCEDURE zears.update_all_reports();
