-- Create Trigger Function to update all_reports table
CREATE OR REPLACE FUNCTION detik.update_all_reports_from_detik()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, image_url, title, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'detik', NEW.disaster_type, NEW.lang, NEW.url, NEW.image_url, NEW.title, NEW.the_geom;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO cognicity.all_reports (fkey, created_at, text, source, disaster_type, lang, url, image_url, title, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'detik', NEW.disaster_type, NEW.lang, NEW.url, NEW.image_url, NEW.title, NEW.the_geom;
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION detik.update_all_reports_from_detik()
  OWNER TO postgres;

CREATE TRIGGER trigger_update_all_reports_from_detik
  BEFORE INSERT OR UPDATE
  ON detik.reports
  FOR EACH ROW
  EXECUTE PROCEDURE detik.update_all_reports_from_detik();

  --Function to update or insert tweet users
  CREATE FUNCTION detik.upsert_users(hash varchar) RETURNS VOID AS
  $$
  BEGIN
      LOOP
          -- first try to update the key
          UPDATE detik.users SET reports_count = reports_count + 1 WHERE user_hash = hash;
          IF found THEN
              RETURN;
          END IF;
          -- not there, so try to insert the key
          -- if someone else inserts the same key concurrently,
          -- we could get a unique-key failure
          BEGIN
              INSERT INTO detik.users(user_hash,reports_count) VALUES (hash, 1);
              RETURN;
          EXCEPTION WHEN unique_violation THEN
              -- Do nothing, and loop to try the UPDATE again.
          END;
      END LOOP;
  END;
  $$
  LANGUAGE plpgsql;
