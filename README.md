CogniCity
===========
**Open Source GeoSocial Intelligence Framework**

#### cognicity-schema: PostgreSQL/PostGIS Schema for CogniCity data.
[![Build Status](https://travis-ci.org/urbanriskmap/cognicity-schema.svg?branch=master)](https://travis-ci.org/urbanriskmap/cognicity-schema)

DOI for current stable release [v3.0.2](https://github.com/urbanriskmap/cognicity-schema/releases/tag/v3.0.2)

[![DOI](https://zenodo.org/badge/70249866.svg)](https://zenodo.org/badge/latestdoi/70249866)

### About
CogniCity-schema is the PostgreSQL/PostGIS database schema for the CogniCity Framework.  The schema contains the tables required for data input by [cognicity-reports](https://github.com/smart-facility/cognicity-reports-powertrack), [cognicity-reports-detik](https://github.com/urbanriskmap/cognicity-reports-detik), [cognicity-reports-lambda](https://github.com/urbanriskmap/cognicity-reports-lambda), [cognicity-reports-telegram](https://github.com/urbanriskmap/cognicity-reports-telegram) and data output using [cognicity-server](https://github.com/urbanriskmap/cognicity-server).

For a comprehensive overview of CogniCity v1.0, including the original database schema see Chapter 2 of:
> "White Paper - PetaJakarta.org:
Assessing the Role of Social Media for Civic Co‑Management During Monsoon Flooding
in Jakarta, Indonesia", 2014. Holderness T & Turpin E. [ISBN 978-1-74128-249-8 ](http://petajakarta.org/banjir/en/research/)

#### Reports
Input data sources for reporting are received into separate schemas, named by report types. Trigger functions in each data source's schema normalise the different report data and push it to the global cognicity.all_reports table (see Table below).

#### Risk Evaluation Matrix (REM)
Flood affected area polygon data provided by emergency services via the REM interface is stored in the cognicity.rem_status table. The geographic data for these areas is stored in the cognicity.local_areas table.

### Tables
#### CogniCity Schema v3.0
| Schema | Table Name | Description |
| ------ | ---------- | ----------- |
| cognicity | all_reports | Confirmed reports of flooding from all data sources |
| cognicity | instance_regions | Regions where CogniCity is currently deployed |
| cognicity | local_areas | Neighbourhood scale unit areas (In Indonesia, these are RWs. In Chennai, these are zones) |
| cognicity| rem_status | Flood state of local_areas as defined by the Risk Evaluation Matrix |
| cognicity| rem_status_log | Log changes to rem_status |
| detik | reports | Reports from Pasangmata citizen journalism app (provided by Detik.com) |
| detik | reports | Users with reports received from Pasangmata citizen journalism app (provided by Detik.com) |
| floodgauge | reports | Live reports of water depths from flood gauges in city |
| grasp | cards | Report cards issued to users via the Geosocial Rapid Assessment Platform (GRASP) |
| grasp | log | Log of activity regarding report cards issued to users via the Geosocial Rapid Assessment Platform (GRASP) |
| grasp | reports | Reports received from users via the Geosocial Rapid Assessment Platform (GRASP) |
| infrastructure | floodgates | Location of flood mitigation infrastructure in each city |
| infrastructure | floodgates | Location of flood mitigation infrastructure in each city |
| infrastructure | pumps | Location of flood mitigation infrastructure in each city |
| infrastructure | waterways | Location of waterways infrastructure in each city |
| public | sensor_data | Data from automated water level sensors in the city |
| public | sensor_metadata | Metadata of automated water level sensors in the city |
| public | spatial_ref_systems | Table created by PostGIS |
| qlue | reports | Reports from the government and citizen reporting application Qlue |
| twitter | invitees | Hashed representation of Twitter users that were automatically contacted by the platform |
| twitter | seen_tweet_id | Last Tweet processed by the cognicity-reports-powertrack module |
| zears | reports | Reports collected from the Zurich "ZMap" application |

#### License for Sample Data
**Indonesia**
<dl>Jakarta's municipal boundaries are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>. <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/80x15.png" /></a></dl>

<dl>Hydrological Infrastructure Data (pumps, floodgates, waterways) is licensed under <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>. <img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/80x15.png"/></a>
</dl>
* Hydrological data are available from [Research Data Australia](https://researchdata.ands.org.au/petajakartaorg/552178) (Australian National Data Service), with DOIs held by the National Library of Australia.

**India**
<dl>Chennai's municipal boundaries courtesy of Chennai Municipal Corportation</dl>
<dl>Chennai hydrological data (waterways) courtesy of Chennai Flood Management (http://chennaifloodmanagement.org/en/layers/geonode:watercourses#category-more)</dl>

### Dependencies
* [PostgreSQL](http://www.postgresql.org) version 9.5 or later, with
* [PostGIS](http://postgis.net) version 2.0 or later

### Installation
* The PostgreSQL database server must be running with a UTF-8 character set.

#### Installing the schema and data
This build `build/run.sh` script looks for the following environment variables:
- $PGHOST
- $PGUSER
- $PGDATABASE
- $COUNTRY (country for instance)
- $DATA (true | false - whether to load data)
- $FUNCTIONS (true | false - whether to load schema functions)
- $SCHEMA (true | false - whether to load schema definitions)

Country names should match the name specified in the `/data/` folder.

To install the database and load data for specified country run:
```sh
$ export COUNTRY=indonesia
$ build/run.sh
```
This will create a database, build the empty schema and insert available data.


#### Use of RDS image
A blank database of the schema is also available as an [RDS](https://aws.amazon.com/rds/) PostgreSQL snapshot in the ap-southeast-1 (Singapore) region, ARN: arn:aws:rds:ap-southeast-1:917524458155:snapshot:cognicity-v3
To use:
* First copy the snapshot to the region (if not ap-southeast-1) where you want to start your instance.
* In the RDS snapshots page for the region where you you want to start your instance, select the copied snapshot and restore it.
* Modify the database, I recommend:
  - creating a new parameter group (from the postgres 9.6 original) that sets rds.force_ssl to 1.
  - setting a password (for user postgres).
  - for production environments, using a multi-AZ setup for redundancy and setting the size to 100 GB for better IOPS performance.

### Testing
Tests are run using NodeJS with Unit.js and Mocha to insert dummy values and perform integration testing on the database against the sample data sources.
To run tests:
```sh
$ npm install
$ npm test
```
### Contribution Guidelines
* Issues are tracked on [GitHub](https://github.com/urbanriskmap/cognicity-schema/issues)

### License
The schema is released under the GPLv3 License. See LICENSE.txt for details.
