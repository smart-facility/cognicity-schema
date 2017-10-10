#!/usr/bin/env bash

# This script creates a new schema and copies data over from production.
# Run this from the root directory e.g. cognicity-schema/

# Define databases
PROD=cognicity
NEW=new_cognicity

# Set env vars
export PGDATABASE=`echo $NEW`
export DATA=false # Disable default data loading in schema script
export PGHOST=localhost
export PG_DEFAULT_DB=cognicity # Upgrade so this exists
export PGUSER=postgres

# Create new database, empty schema
source build/run.sh

# Optional updates to old database
# Edit the old database - replace card id with UUID
## psql -d $PROD -h $PGHOST -U $PGUSER -f schema/reports/grasp/grasp.uuid_upgrade.sql

# Copy the old data to the new database
pg_dump -a $PROD -h $PGHOST -U $PGUSER --disable-triggers -t cognicity.* -t detik.* -t floodgauge.* -t grasp.* -t infrastructure.* -t public.* -t qlue.* -t sensors.* -t twitter.* -t zears.* | psql -d $NEW -h $PGHOST -U $PGUSER

# Kill prod connections
psql -d $PROD -h $PGHOST -U $PGUSER -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$PROD' AND pid <> pg_backend_pid();"

psql -d $NEW -h $PGHOST -U $PGUSER -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$NEW' AND pid <> pg_backend_pid();"

# Append prod with _old suffix
OLD=$PROD'_old'
psql -d $NEW -h $PGHOST -U $PGUSER -c "ALTER DATABASE \"$PROD\" RENAME TO \"$OLD\""

# Rename new to prod
psql -d $OLD -h $PGHOST -U $PGUSER -c "ALTER DATABASE \"$NEW\" RENAME TO \"$PROD\""
