CREATE SCHEMA sensors;

-- Sensor locations table
CREATE TABLE sensors.metadata
(
  id bigserial NOT NULL,
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  properties JSONB NOT NULL,
  CONSTRAINT sensors_metadata_pkey PRIMARY KEY (id)
);

-- Add a geometry column
SELECT AddGeometryColumn('sensors', 'metadata', 'the_geom', 4326, 'POINT', 2);
ALTER TABLE sensors.metadata ALTER COLUMN the_geom SET NOT NULL;

-- Add a GIST spatial index
CREATE INDEX gix_sensor_metadata ON sensors.metadata USING gist(the_geom);

-- Create index on created column
CREATE INDEX idx_sensor_metadata_created ON sensors.metadata (created);

-- Sensor data table
CREATE TABLE sensors.data
(
  id bigserial NOT NULL,
  sensor_id bigint NOT NULL,
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  properties JSONB NOT NULL,
  CONSTRAINT sensors_data_pkey PRIMARY KEY (id),
  CONSTRAINT sensors_data_fkey FOREIGN KEY (sensor_id)
    REFERENCES sensors.metadata (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Create index on created column
CREATE INDEX idx_sensor_data_created ON sensors.data (created);
