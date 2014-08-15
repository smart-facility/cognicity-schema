CREATE TABLE rw_count_reports_unconfirmed (pkey bigserial, rw_pkey integer, count integer, start_time TIMESTAMP WITH TIME ZONE, end_time TIMESTAMP WITH TIME ZONE,
CONSTRAINT rw_count_uc_pkey PRIMARY KEY (pkey));

CREATE TABLE rw_count_reports_confirmed (pkey bigserial, rw_pkey integer, count integer, start_time TIMESTAMP WITH TIME ZONE, end_time TIMESTAMP WITH TIME ZONE,
CONSTRAINT rw_count_pkey PRIMARY KEY (pkey));