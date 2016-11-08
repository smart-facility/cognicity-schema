-- Need to add properties push to all_reports e.g. flood heights.

-- Push grasp reports to CogniCity all reports
CREATE OR REPLACE FUNCTION grasp.update_all_reports_from_grasp()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, properties, the_geom)
        SELECT NEW.pkey, NEW.created_at, NEW.text, 'grasp', NEW.disaster_type, card.language, 'data.petabencana.id/'||card.card_id, NEW.card_data, NEW.the_geom
        FROM grasp.cards AS card WHERE card.card_id = NEW.card_id;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, properties, the_geom)
      SELECT NEW.pkey, NEW.created_at, NEW.text, 'grasp', NEW.disaster_type, card.language, 'data.petabencana.id/'||card.card_id, NEW.card_data, NEW.the_geom
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
