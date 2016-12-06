-- Create schema
CREATE schema qlue;

-- Create table for Qlue reports
CREATE TABLE qlue.reports
(
  pkey bigserial NOT NULL,
  post_id bigint NOT NULL UNIQUE,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type character varying NOT NULL,
  text character varying,
  lang character varying,
  image_url character varying,
  title character varying,
  qlue_city character varying NOT NULL,
  CONSTRAINT pkey_qlue PRIMARY KEY (pkey)
);

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('qlue','reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_qlue_reports ON qlue.reports USING gist (the_geom);
