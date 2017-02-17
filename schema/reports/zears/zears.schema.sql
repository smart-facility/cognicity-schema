-- template_data_source Schema for report data source
CREATE SCHEMA zears;

-- Create table for Twitter reports
CREATE TABLE zears.reports
(
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  source character varying,
  disaster_type varchar NOT NULL,
  title character varying,
  text character varying,
  lang character varying,
  url character varying,
  image_url character varying,
  report_data json,
  CONSTRAINT pkey_reports PRIMARY KEY (pkey)
);

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('zears','reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_zears_data_source_reports ON zears.reports USING gist (the_geom);
