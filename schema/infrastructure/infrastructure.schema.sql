CREATE SCHEMA infrastructure;

CREATE TABLE infrastructure.floodgates (
    pkey bigserial,
    name character varying(50),
    tags json,
    CONSTRAINT floodgates_pkey PRIMARY KEY (pkey)
);
SELECT AddGeometryColumn ('infrastructure','floodgates','the_geom',4326,'POINT',3);
ALTER TABLE infrastructure.floodgates ALTER COLUMN the_geom SET NOT NULL;

CREATE TABLE infrastructure.pumps (
    pkey bigserial,
    name character varying(50),
    tags json,
    CONSTRAINT pumps_pkey PRIMARY KEY (pkey)

);
SELECT AddGeometryColumn ('infrastructure','pumps','the_geom',4326,'POINT',3);
ALTER TABLE infrastructure.pumps ALTER COLUMN the_geom SET NOT NULL;

CREATE TABLE infrastructure.waterways (
    pkey bigserial,
    name character varying(50),
    tags json,
    CONSTRAINT waterways_pkey PRIMARY KEY (pkey)

);
SELECT AddGeometryColumn ('infrastructure','waterways','the_geom',4326,'LINESTRING',3);
ALTER TABLE infrastructure.waterways ALTER COLUMN the_geom SET NOT NULL;
