#!/usr/bin/env bash

# This script creates a new schema and copies data over from existing instance.
# Run this from the root directory e.g. cognicity-schema/

# Define databases
OLD_DATABASE=cognicity
NEW_DATABASE=new_cognicity2

# Set env vars
export PGDATABASE=`echo $NEW_DATABASE`
export DATA=false # Disable default data loading

# Create new database, empty schema
source build/run.sh

# Optional updates to old database
# Edit the old database - replace card id with UUID
psql -d $OLD_DATABASE -f schema/reports/grasp/grasp.uuid_upgrade.sql

# Copy the old data to the new database
pg_dump -a $OLD_DATABASE --disable-triggers | psql -d $NEW_DATABASE
