#!/usr/bin/env bash
# Config
PGHOST=${PGHOST:-'localhost'}
PGUSER=${PGUSER:-'postgres'}
COUNTRY=${COUNTRY:-'indonesia'}
PGDATABASE=${PGDATABASE:-'cognicity'}
PGPORT=${PGPORT:-'5432'}

DATA=${DATA:-true} # optional load data flag (set false to skip data loading)
FUNCTIONS=${FUNCTIONS:-true} # optional load functions flag
SCHEMA=${SCHEMA:-true} #optional schema flag

if [ $SCHEMA == true ]; then
  # Create Database
  # Build command
  BUILD="CREATE DATABASE \"$PGDATABASE\" WITH OWNER = \"$PGUSER\" ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1;"

  psql -h $PGHOST -p $PGPORT -U $PGUSER -d postgres -c """$BUILD"""

  # Load postgis extensions
  POSTGIS="CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology; CREATE EXTENSION fuzzystrmatch; CREATE EXTENSION address_standardizer; CREATE EXTENSION postgis_tiger_geocoder;"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c """$POSTGIS"""

  # Load UUID extension
  UUID="CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c """$UUID"""

  # Load schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.schema.sql

  # Load reports template schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/template/template.schema.sql

  # Load the twitter (grasp version) reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/twitter/twitter.schema.sql

  # Load the grasp reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/grasp/grasp.schema.sql

  # Load the detik reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/detik/detik.schema.sql

  # Load the qlue reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/qlue/qlue.schema.sql

  # Load the zears report schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/zears/zears.schema.sql

  # Load the floodgauge reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/floodgauge/floodgauge.schema.sql

  # Load the pumps, floodgates and waterways infrastructure schema data
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/infrastructure/infrastructure.schema.sql

  # Load sensor schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/sensors/watersensor.schema.sql
fi

# Functions loading
if [ $FUNCTIONS == true ]; then
  # Load functions
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/template/template.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/grasp/grasp.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/detik/detik.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/qlue/qlue.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/zears/zears.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./schema/reports/floodgauge/floodgauge.functions.sql
fi

# Static data loading
if [ $DATA == true ]; then
  # Load instance data - regions
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./data/$COUNTRY/cognicity/instance_regions.data.sql

  # Load instance data - local areas
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./data/$COUNTRY/cognicity/local_areas.data.sql

  # Load available infrastructure for selected country
  for entry in ./data/$COUNTRY/infrastructure/*.sql
  do
    psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $entry
  done

  # Initialize last seen tweet id
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f ./data/$COUNTRY/reports/twitter.data.sql
fi
