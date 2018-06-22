CHANGE LOG
==========

### v3.0.4
- added sensors schema
- dropped public schema from upgrade script
- added data for Mumbai and Bangalore
- added test support for multiple instances per deployment
- added tests for Surabaya and Bandung

### v3.0.5
- added Semarang extents to Indonesian data
- added test instance parameters for Semarang
- removed default parameters from database build script

### v3.0.6
- documented release procedure in README.md
- added RDS permissions script
- added table reports_points_log
- added district_id field to local_areas data in Indonesia
- added district_id field to tags property of reports

### v3.0.7
- updated Travis tests against PostgreSQL v10 with PostGIS v2.4
- updated Travis tests to use Node v8.9.3 (production)
- updated README.md minimum requirements
- added 'attributes' column to local_areas
- implemented new notification architecture
- requires cognicity-server v3.0.6 or later
- handle null instance region codes

### v3.1.0
