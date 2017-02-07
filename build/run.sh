#!/usr/bin/env bash
# Config
PGHOST=${PGHOST:-'localhost'}
PGUSER=${PGUSER:-'postgres'}
PGDATABASE=${DATABASE:-'cognicity'} # Note: If you change this name don't forget to change it in the cognicity.createdb.sql file below

# Create db (optional)
psql -h $PGHOST -U $PGUSER -d postgres -T template0 -f ./build/cognicity.createdb.sql

# Load schema
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.schema.sql

# Load functions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/cognicity/cognicity.functions.sql

# Load instance data - regions
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/cognicity/instance_regions.data.sql

# Load instance data - local areas
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/cognicity/local_areas.data.sql

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
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/infrastructure/floodgates.data.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/infrastructure/pumps.data.sql
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./data/infrastructure/waterways.data.sql

# Load sensor schema
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ./schema/sensors/watersensor.schema.sql
