-- Template Schema for report data source
CREATE SCHEMA template;

-- Create table for Twitter reports
CREATE TABLE template.reports
(
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type json NOT NULL,
  text character varying,
  hashtags json,
  text_urls character varying,
  user_mentions json,
  lang character varying,
  url character varying,
  tweet_id bigint,
  CONSTRAINT pkey_tweets PRIMARY KEY (pkey)
);

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('template','reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_template_reports ON template.reports USING gist (the_geom);
