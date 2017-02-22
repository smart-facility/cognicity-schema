#!/usr/bin/env bash
# Config
PGHOST=${PGHOST:-'localhost'}
PGUSER=${PGUSER:-'postgres'}
PGDATABASE=${DATABASE:-'cognicity_indonesia_2'}
COUNTRY=${COUNTRY:-'indonesia'}

# Create Database
# Build command
BUILD="CREATE DATABASE \"$PGDATABASE\" WITH OWNER = \"$PGUSER\" ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1;"

psql -h $PGHOST -U $PGUSER -d postgres -T template0 -c """$BUILD"""

# Load schema
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.schema.sql

# Load functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.functions.sql

# Load instance data - regions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/$COUNTRY/cognicity/instance_regions.data.sql

# Load instance data - local areas
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/$COUNTRY/cognicity/local_areas.data.sql

# Load reports template schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/template/template.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/template/template.functions.sql

# Load the twitter (grasp version) reports schema
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/twitter/twitter.schema.sql

# Load the grasp reports schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/grasp/grasp.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/grasp/grasp.functions.sql

# Load the detik reports schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/detik/detik.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/detik/detik.functions.sql

# Load the qlue reports schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/qlue/qlue.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/qlue/qlue.functions.sql

# Load the zears report schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/zears/zears.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/zears/zears.functions.sql

# Load the floodgauge reports schema & functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/floodgauge/floodgauge.schema.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/reports/floodgauge/floodgauge.functions.sql

# Load the pumps, floodgates and waterways infrastructure schema data
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/infrastructure/infrastructure.schema.sql

# Load available infrastructure for selected country
for entry in ./data/$COUNTRY/infrastructure/*.sql
do
  psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f $entry
done

# Load sensor schema
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/sensors/watersensor.schema.sql
