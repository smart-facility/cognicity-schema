-- Need to add properties push to all_reports e.g. flood heights.

-- Push grasp reports to CogniCity all reports
CREATE OR REPLACE FUNCTION grasp.update_all_reports_from_grasp()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
      UPDATE cognicity.all_reports SET image_url = NEW.image_url WHERE fkey = NEW.pkey AND source = 'grasp';
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

--Notifications on  grasp cards table updates
CREATE OR REPLACE FUNCTION grasp.notify_grasp_cards_trigger() RETURNS trigger AS $$
DECLARE
report_id BIGINT;
report_area VARCHAR;
BEGIN
  SELECT into report_id, report_area c.PKEY, c.tags->>'instance_region_code' FROM cognicity.all_reports c, grasp.reports g WHERE c.fkey = g.pkey AND c.source = 'grasp' AND g.card_id = NEW.card_id;
  PERFORM pg_notify('watchers', '{"' || TG_TABLE_NAME || '":{"pkey":"' || NEW.pkey || '", "username": "'|| NEW.username ||'", "network": "' || NEW.network || '", "language": "'|| NEW.language ||'", "report_id": "' || report_id ||'", "report_impl_area": "' || report_area || '"}}' );
  RETURN new;
END;
$$ LANGUAGE plpgsql;
    
CREATE TRIGGER watch_grasp_cards_trigger
  AFTER UPDATE ON grasp.cards
  FOR EACH ROW
  WHEN (NEW.received = TRUE)
  EXECUTE PROCEDURE grasp.notify_grasp_cards_trigger();
