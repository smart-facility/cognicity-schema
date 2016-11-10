#!/usr/bin/env bash
# Config
HOST='localhost'
USERNAME='postgres'
DATABASE='cognicity' # Note: If you change this name don't forget to change it in the cognicity.createdb.sql file below

# Create db (optional)
psql -h $HOST -U $USERNAME -f ./build/cognicity.createdb.sql

# Load schema
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/cognicity/cognicity.schema.sql

# Load functions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/cognicity/cognicity.functions.sql

# Load instance data - regions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./data/cognicity/instance_regions.data.sql

# Load instance data - local areas
psql -h $HOST -U $USERNAME -d $DATABASE -f ./data/cognicity/local_areas.data.sql

# Load reports template schema & functions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/template/template.schema.sql
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/template/template.functions.sql

# Load the twitter (grasp version) reports schema
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/twitter/twitter.schema.sql

# Load the grasp reports schema & functions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/grasp/grasp.schema.sql
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/grasp/grasp.functions.sql

# Load the detik reports schema & functions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/detik/detik.schema.sql
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/detik/detik.functions.sql

# Load the qlue reports schema & functions
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/qlue/qlue.schema.sql
psql -h $HOST -U $USERNAME -d $DATABASE -f ./schema/reports/qlue/qlue.functions.sql
