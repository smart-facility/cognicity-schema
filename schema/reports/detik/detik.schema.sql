-- Schema for Detik data
CREATE SCHEMA detik;

-- Create table for Detik reports
CREATE TABLE detik.reports
(
  pkey bigserial NOT NULL,
  contribution_id bigint NOT NULL UNIQUE,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type character varying NOT NULL,
  text character varying,
  lang character varying,
  url character varying,
  image_url character varying,
  title character varying,
  CONSTRAINT pkey_detik PRIMARY KEY (pkey)
);

-- Add Geometry column to tweet_reports
SELECT AddGeometryColumn ('detik','reports','the_geom',4326,'POINT',2);

-- Add GIST spatial index
CREATE INDEX gix_detik_reports ON detik.reports USING gist (the_geom);

-- Create table for Detik report users
CREATE TABLE detik.users
(
  pkey bigserial,
  user_hash character varying UNIQUE,
  reports_count integer	,
  CONSTRAINT pkey_detik_users PRIMARY KEY (pkey)
);
