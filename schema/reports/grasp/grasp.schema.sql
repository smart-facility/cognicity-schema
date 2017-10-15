-- Create schema for GRASP reports (cross-data source)
CREATE schema grasp;

--Table grasp_card_id (card_id, received[true/false])
CREATE TABLE grasp.cards (
  pkey bigserial NOT NULL,
  card_id uuid NOT NULL UNIQUE DEFAULT uuid_generate_v4(),
  username varchar NOT NULL,
  network varchar NOT NULL,
  language varchar NOT NULL,
  received boolean,
  CONSTRAINT pkey_grasp_cards PRIMARY KEY (pkey)
);

--Table grasp_reports
CREATE TABLE grasp.reports (
  pkey bigserial NOT NULL,
  card_id uuid NOT NULL UNIQUE,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type varchar NOT NULL,
  text varchar,
  card_data json,
  image_url varchar,
  status varchar,
  the_geom geometry(Point, 4326),
  CONSTRAINT pkey_grasp_reports PRIMARY KEY (pkey)
);

--Table grasp_log
CREATE TABLE grasp.log (
  pkey bigserial NOT NULL,
  database_time timestamp with time zone DEFAULT now(),
  card_id varchar,
  --user_id,
  event_type varchar,
  CONSTRAINT pkey_grasp_log PRIMARY KEY (pkey)
);
