#!/usr/bin/env bash

# Exit 1 on any error
set -e

# Config
PGHOST=${PGHOST:-'localhost'}
PGUSER=${PGUSER:-'postgres'}
COUNTRY=${COUNTRY:-'indonesia'}
PGDATABASE=${PGDATABASE:-'cognicity'}
PGPORT=${PGPORT:-'5432'}
PG_DEFAULT_DB=${PG_DEFAULT_DB:-'postgres'}

DATA=${DATA:-true} # optional load data flag (set false to skip data loading)
FUNCTIONS=${FUNCTIONS:-true} # optional load functions flag
SCHEMA=${SCHEMA:-true} #optional schema flag

if [ $SCHEMA == true ]; then
  # Create Database
  # Build command
  echo "Create database"
  BUILD="CREATE DATABASE \"$PGDATABASE\" WITH OWNER = \"$PGUSER\" ENCODING = 'UTF8';"

  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PG_DEFAULT_DB -c """$BUILD"""

  echo "Load PostGIS"
  # Load postgis extensions
  POSTGIS="CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology; CREATE EXTENSION fuzzystrmatch; CREATE EXTENSION address_standardizer; CREATE EXTENSION postgis_tiger_geocoder;"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c """$POSTGIS"""

  # Fix AWS RDS permissions if need
  echo "Check if RDS user present and fix permissions if needed"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/build/set_rds_postgis_permissions.sql

  echo "Load UUID"
  # Load UUID extension
  UUID="CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c """$UUID"""

  echo "Load schema"
  # Load schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/cognicity/cognicity.schema.sql

  echo "Load reports template schema"
  # Load reports template schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/template/template.schema.sql

  echo "Load twitter reports schema"
  # Load the twitter (grasp version) reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/twitter/twitter.schema.sql

  echo "Load grasp reports schema"
  # Load the grasp reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/grasp/grasp.schema.sql

  echo "Load detik reports schema"
  # Load the detik reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/detik/detik.schema.sql

  echo "Load qlue reports schema"
  # Load the qlue reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/qlue/qlue.schema.sql

  echo "Load zears report schema"
  # Load the zears report schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/zears/zears.schema.sql

  echo "Load floodgauge reports schema"
  # Load the floodgauge reports schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/floodgauge/floodgauge.schema.sql

  echo "Load infrastructure schema"
  # Load the pumps, floodgates and waterways infrastructure schema data
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/infrastructure/infrastructure.schema.sql

  echo "Load water sensor schema"
  # Load sensor schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/sensors/watersensor.schema.sql

  echo "Load new sensors schema"
  # Load sensors schema
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/sensors/sensors.schema.sql
fi

# Functions loading
if [ $FUNCTIONS == true ]; then
  echo "Load functions"
  # Load functions
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/cognicity/cognicity.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/template/template.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/grasp/grasp.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/detik/detik.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/qlue/qlue.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/zears/zears.functions.sql
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/schema/reports/floodgauge/floodgauge.functions.sql
fi

# Static data loading
if [ $DATA == true ]; then
  echo "Load data"
  # Load instance data - regions
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/data/$COUNTRY/cognicity/instance_regions.data.sql

  # Load instance data - local areas
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/data/$COUNTRY/cognicity/local_areas.data.sql

  # Load available infrastructure for selected country
  for entry in $(pwd)/data/$COUNTRY/infrastructure/*.sql
  do
    psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $entry
  done

  # Initialize last seen tweet id
  psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f $(pwd)/data/$COUNTRY/reports/twitter.data.sql
fi
