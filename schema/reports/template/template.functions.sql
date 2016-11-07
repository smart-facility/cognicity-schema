-- Create Trigger Function to update all_reports table
CREATE OR REPLACE FUNCTION template_data_source.update_all_reports()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'data_source', NEW.disaster_type, NEW.lang, NEW.url, NEW.the_geom;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'data_source', NEW.disaster_type, NEW.lang, NEW.url, NEW.the_geom;
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION template_data_source.update_all_reports()
  OWNER TO postgres;

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports
  BEFORE INSERT OR UPDATE
  ON template_data_source.reports
  FOR EACH ROW
  EXECUTE PROCEDURE template_data_source.update_all_reports();
