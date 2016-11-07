-- Create schema for GRASP reports (cross-data source)
CREATE schema grasp;

--Table grasp_card_id (card_id, received[true/false])
CREATE TABLE grasp.cards (
  pkey bigserial NOT NULL,
  card_id varchar NOT NULL UNIQUE,
  username varchar NOT NULL,
  network varchar NOT NULL,
  language varchar NOT NULL,
  received boolean,
  report_id bigint UNIQUE,
  CONSTRAINT pkey_grasp_cards PRIMARY KEY (pkey)
);

--Table grasp_reports
CREATE TABLE grasp.reports (
  pkey bigserial NOT NULL,
  card_id varchar NOT NULL UNIQUE,
  database_time timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone,
  disaster_type varchar NOT NULL,
  text varchar,
  card_data json,
  image_id bigint,
  status varchar,
  the_geom geometry(Point, 4326),
  CONSTRAINT pkey_grasp_reports PRIMARY KEY (pkey)
);

--Table grasp_report_images
CREATE TABLE grasp.report_images (
  pkey bigserial NOT NULL,
  card_id varchar NOT NULL,
  image_id bigint,
  filename varchar,
  url_path varchar,
  CONSTRAINT pkey_grasp_report_images PRIMARY KEY (pkey)
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
