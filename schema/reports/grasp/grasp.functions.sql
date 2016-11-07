-- Push grasp reports to CogniCity all reports
CREATE OR REPLACE FUNCTION grasp.update_all_reports()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, the_geom)
        SELECT NEW.pkey, NEW.created_at, NEW.text, 'grasp', NEW.disaster_type, card.language, 'data.petabencana.id/'||card.card_id, NEW.the_geom
        FROM grasp.cards AS card WHERE card.card_id = NEW.card_id;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, the_geom)
      SELECT NEW.pkey, NEW.created_at, NEW.text, 'grasp', NEW.disaster_type, card.language, 'data.petabencana.id/'||card.card_id, NEW.the_geom
      FROM grasp.cards AS card WHERE card.card_id = NEW.card_id;
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION grasp.update_all_reports()
  OWNER TO postgres;

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports
  BEFORE INSERT OR UPDATE
  ON grasp.reports
  FOR EACH ROW
  EXECUTE PROCEDURE grasp.update_all_reports();


-- Notifications on grasp cards table updates
CREATE FUNCTION grasp.notify_grasp_cards_trigger() RETURNS trigger AS $$
DECLARE
BEGIN
  PERFORM pg_notify('watchers', '{"' || TG_TABLE_NAME || '":{"pkey":"' || NEW.pkey || '", "username": "'|| NEW.username ||'", "network": "' || NEW.network || '", "language": "'|| NEW.language ||'", "report_id": "' || NEW.report_id || '"}}' );
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- Trigger for grasp card table updates
CREATE TRIGGER watch_grasp_cards_trigger
  AFTER UPDATE ON grasp.cards
  FOR EACH ROW
  WHEN (NEW.received = TRUE)
  EXECUTE PROCEDURE grasp.notify_grasp_cards_trigger();
