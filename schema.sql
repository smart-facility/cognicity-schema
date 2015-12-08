-- Spatial extensions
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

-- Create Trigger Function to update all_reports table
CREATE OR REPLACE FUNCTION public.update_all_reports_from_tweets()
  RETURNS trigger AS
$BODY$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO all_reports (fkey, created_at, text, source, lang, url, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'twitter', NEW.lang, NEW.url, NEW.the_geom;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO all_reports (fkey, created_at, text, source, lang, url, the_geom) SELECT NEW.pkey, NEW.created_at, NEW.text, 'twitter', NEW.lang, NEW.url, NEW.the_geom;
			RETURN NEW;
		END IF;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.update_all_reports_from_tweets()
  OWNER TO postgres;

-- Table: tweet_reports
-- DROP TABLE tweet_reports;

-- Create table for Twitter reports
CREATE TABLE tweet_reports
(
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  text character varying,
  hashtags json,
  text_urls character varying,
  user_mentions json,
  lang character varying,
  url character varying,
  tweet_id bigint,
  CONSTRAINT pkey_tweets PRIMARY KEY (pkey)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE tweet_reports
  OWNER TO postgres;

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('public','tweet_reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_tweet_reports ON tweet_reports USING gist (the_geom);

-- Update all_reports table
CREATE TRIGGER trigger_update_all_reports_from_tweets
  BEFORE INSERT OR UPDATE
  ON public.tweet_reports
  FOR EACH ROW
  EXECUTE PROCEDURE public.update_all_reports_from_tweets();

-- Create table for Twitter report users
CREATE TABLE tweet_users
(
  pkey bigserial,
  user_hash character varying UNIQUE,
  reports_count integer	,
  CONSTRAINT pkey_tweet_users PRIMARY KEY (pkey)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE tweet_users
  OWNER TO postgres;

-- Create table for non spatial tweets
CREATE TABLE nonspatial_tweet_reports
(
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  text character varying,
  hashtags json,
  urls character varying,
  user_mentions json,
  lang character varying,
  CONSTRAINT pkey_nonspatial_tweets PRIMARY KEY (pkey)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nonspatial_tweet_reports
  OWNER TO postgres;

-- Create table for unconfirmed tweet reports
CREATE TABLE tweet_reports_unconfirmed
(
 pkey bigserial,
 database_time timestamp with time zone DEFAULT now(),
 created_at timestamp with time zone,
 CONSTRAINT pkey_tweet_reports_unconfirmed PRIMARY KEY (pkey)
);
-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('public','tweet_reports_unconfirmed','the_geom',4326,'POINT',2);

-- Creat Gist spatial index on unconfirmed reports
CREATE INDEX gix_tweet_reports_unconfirmed ON tweet_reports_unconfirmed USING gist (the_geom);

-- Tweet invitees
CREATE TABLE tweet_invitees
(
 pkey bigserial,
 user_hash character varying UNIQUE,
 CONSTRAINT pkey_tweet_invitees PRIMARY KEY (pkey)
);

-- Create table for Twitter users with reports without geospatial metadata
CREATE TABLE nonspatial_tweet_users
(
  pkey bigserial,
  user_hash character varying UNIQUE,
  CONSTRAINT nonspatial_tweet_users_pkey PRIMARY KEY (pkey)
);

-- Create a consolidated table for all users, regardless of data source
CREATE TABLE tweet_all_users
(
 pkey bigserial,
 user_hash character varying UNIQUE,
 CONSTRAINT tweet_all_users_pkey PRIMARY KEY (pkey)
);

CREATE unique INDEX tweet_all_users_index ON tweet_all_users(user_hash);

-- Create a function to update tweet_all_users. Should be called by each data source table (e.g. tweet_reports)
CREATE OR REPLACE FUNCTION update_tweet_all_users()
  RETURNS trigger AS $update_tweet_all_users$

	BEGIN
		INSERT INTO tweet_all_users(user_hash) SELECT NEW.user_hash WHERE NOT EXISTS (SELECT user_hash FROM tweet_all_users WHERE user_hash = NEW.user_hash);
		RETURN NEW;
	END;

$update_tweet_all_users$ LANGUAGE plpgsql;

CREATE TRIGGER non_spatial_all_users BEFORE INSERT OR UPDATE ON nonspatial_tweet_users
	FOR EACH ROW EXECUTE PROCEDURE update_tweet_all_users();
CREATE TRIGGER tweet_invitees_all_users BEFORE INSERT OR UPDATE ON tweet_invitees
	FOR EACH ROW EXECUTE PROCEDURE update_tweet_all_users();
CREATE TRIGGER tweet_users_all_users BEFORE INSERT OR UPDATE ON tweet_users
	FOR EACH ROW EXECUTE PROCEDURE update_tweet_all_users();

--Function to update or insert tweet users
CREATE FUNCTION upsert_tweet_users(hash varchar) RETURNS VOID AS
$$
BEGIN
    LOOP
        -- first try to update the key
        UPDATE tweet_users SET reports_count = reports_count + 1 WHERE user_hash = hash;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO tweet_users(user_hash,reports_count) VALUES (hash, 1);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- Do nothing, and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$
LANGUAGE plpgsql;

-- Create Table to store reports
CREATE TABLE all_reports
(
  pkey bigserial NOT NULL,
  fkey bigint NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  text character varying NOT NULL,
  source character varying NOT NULL,
  status character varying DEFAULT 'confirmed',
  lang character varying,
  url character varying,
  image_url character varying,
  title character varying,
  CONSTRAINT all_tweets PRIMARY KEY (pkey)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE all_reports
  OWNER TO postgres;

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('public','all_reports','the_geom',4326,'POINT',2);
ALTER TABLE all_reports ALTER COLUMN the_geom SET NOT NULL;

-- Add GIST spatial index
CREATE INDEX gix_all_reports ON all_reports USING gist (the_geom);

-- Document the table
COMMENT ON TABLE all_reports IS 'Reports from all input data sources';
COMMENT ON COLUMN all_reports.pkey IS '{bigserial} [Primary Key] Unique key for each report';
COMMENT ON COLUMN all_reports.fkey IS '{bigint} [Foreign Key] Unique key from source data table';
COMMENT ON COLUMN all_reports.database_time IS '{timestamp with timezone} Time report written to table';
COMMENT ON COLUMN all_reports.created_at IS '{timestamp with timezone} Time of report as recorded at data source';
COMMENT ON COLUMN all_reports.text IS '{character varying} The text of the report';
COMMENT ON COLUMN all_reports.source IS '{character varying} Data source of the report';
COMMENT ON COLUMN all_reports.status IS '{character varying} Status of the report (defaults to confirmed)';
COMMENT ON COLUMN all_reports.lang IS '{character varying | NULL} Language of report text in all_reports.text';
COMMENT ON COLUMN all_reports.url IS '{character varying | NULL} URL link to report data source';
COMMENT ON COLUMN all_reports.image_url IS '{character varying | NULL} URL link to report image';
COMMENT ON COLUMN all_reports.title IS '{character varying | NULL} Short description of report';
COMMENT ON COLUMN all_reports.the_geom IS '{geometry object} Point location for report using the WGS 1984 coordinate reference system';
COMMENT ON INDEX gix_tweet_reports IS 'Generalized Search Tree Index on all_reports.the_geom';
