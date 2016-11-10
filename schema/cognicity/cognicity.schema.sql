CREATE SCHEMA cognicity;

-- Spatial extensions
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

-- All Reports Table
-- Create Table to store reports
CREATE TABLE cognicity.all_reports
(
  pkey bigserial NOT NULL,
  fkey bigint NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  text character varying NOT NULL,
  source character varying NOT NULL,
  status character varying DEFAULT 'confirmed',
  disaster_type character varying NOT NULL,
  lang character varying,
  url character varying,
  image_url character varying,
  title character varying,
  report_data json,
  tags json,
  CONSTRAINT all_reports_pkey PRIMARY KEY (pkey)
);

-- Add Geometry column to all_reports
SELECT AddGeometryColumn ('cognicity','all_reports','the_geom',4326,'POINT',2);
ALTER TABLE cognicity.all_reports ALTER COLUMN the_geom SET NOT NULL;

-- Add GIST spatial index
CREATE INDEX gix_all_reports ON cognicity.all_reports USING gist (the_geom);

-- Instance Regions Table
CREATE TABLE cognicity.instance_regions(
  pkey bigserial NOT NULL,
  code character varying,
  name character varying,
  CONSTRAINT instance_regions_pkey PRIMARY KEY (pkey)
);

-- Add Geometry column to instance_regions
SELECT AddGeometryColumn ('cognicity', 'instance_regions', 'the_geom', 4326, 'POLYGON', 2);
ALTER TABLE cognicity.instance_regions ALTER COLUMN the_geom SET NOT NULL;

-- Add a GIST spatial index
CREATE INDEX gix_instance_regions ON cognicity.instance_regions USING gist (the_geom);

-- Local areas table (Indonesia = RWs)
CREATE TABLE cognicity.local_areas(
  pkey bigserial NOT NULL,
  geom_id bigint NOT NULL,
  area_name character varying,
  parent_name character varying,
  city_name character varying,
  instance_region_code character varying NOT NULL,
  CONSTRAINT local_area_pkey PRIMARY KEY (pkey)
);

-- Add Geometry column to local_areas
SELECT AddGeometryColumn ('cognicity', 'local_areas', 'the_geom', 4326, 'Geometry', 2);
ALTER TABLE cognicity.local_areas ALTER COLUMN the_geom SET NOT NULL;

-- Add a GIST spatial index
CREATE INDEX gix_local_areas ON cognicity.local_areas USING gist (the_geom);

-- CREATE TABLE
-- REM status table
CREATE TABLE cognicity.rem_status
(
  local_area bigint NOT NULL,
  state integer,
  last_updated timestamp with time zone DEFAULT now(),
  CONSTRAINT rem_status_pkey PRIMARY KEY (local_area),
  CONSTRAINT rem_status_local_area_fkey FOREIGN KEY (local_area)
      REFERENCES cognicity.local_areas (pkey) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE cognicity.rem_status_log
(
  local_area bigint,
  state integer,
  changed timestamp with time zone DEFAULT now(),
  id bigserial NOT NULL,
  username character varying,
  CONSTRAINT rem_status_log_id_pkey PRIMARY KEY (id)
);
