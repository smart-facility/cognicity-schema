-- template_data_source Schema for report data source
CREATE SCHEMA template_data_source;

-- Create table for Twitter reports
CREATE TABLE template_data_source.reports
(
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type varchar NOT NULL,
  text character varying,
  lang character varying,
  url character varying,
  CONSTRAINT pkey_reports PRIMARY KEY (pkey)
);

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('template_data_source','reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_template_data_source_reports ON template_data_source.reports USING gist (the_geom);
