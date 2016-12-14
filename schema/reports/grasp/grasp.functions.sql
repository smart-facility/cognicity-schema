-- Need to add properties push to all_reports e.g. flood heights.

-- Push grasp reports to CogniCity all reports
CREATE OR REPLACE FUNCTION grasp.update_all_reports_from_grasp()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
      UPDATE cognicity.all_reports SET (image_url) = NEW.image_url WHERE fkey = NEW.pkey AND source = 'grasp'
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, report_data, the_geom, image_url)
      SELECT NEW.pkey, NEW.created_at, NEW.text, 'grasp', NEW.disaster_type, card.language, 'data.petabencana.id/cards/'||card.card_id, NEW.card_data, NEW.the_geom, NEW.image_url
      FROM grasp.cards AS card WHERE card.card_id = NEW.card_id;
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION grasp.update_all_reports_from_grasp()
  OWNER TO postgres;

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports_from_grasp
  BEFORE INSERT OR UPDATE
  ON grasp.reports
  FOR EACH ROW
  EXECUTE PROCEDURE grasp.update_all_reports_from_grasp();
