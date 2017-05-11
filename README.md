CogniCity
===========
**Open Source GeoSocial Intelligence Framework**

#### cognicity-schema: PostgreSQL/PostGIS Schema for CogniCity data.
[![Build Status](https://travis-ci.org/urbanriskmap/cognicity-schema.svg?branch=master)](https://travis-ci.org/urbanriskmap/cognicity-schema)

DOI for current stable release [v2.0.0](https://github.com/smart-facility/cognicity-schema/releases/tag/v2.0.0): [![DOI](https://zenodo.org/badge/19201/smart-facility/cognicity-schema.svg)](https://zenodo.org/badge/latestdoi/19201/smart-facility/cognicity-schema)

### About
CogniCity-schema is the PostgreSQL/PostGIS database schema for the CogniCity Framework.  The schema contains the tables required for data input by [cognicity-reports](https://github.com/smart-facility/cognicity-reports-powertrack) and data output using [cognicity-server](https://github.com/smart-facility/cognicity-server).

For a comprehensive overview of CogniCity v1.0, including the original database schema see Chapter 2 of:
> "White Paper - PetaJakarta.org:
Assessing the Role of Social Media for Civic Co‑Management During Monsoon Flooding
in Jakarta, Indonesia", 2014. Holderness T & Turpin E. [ISBN 978-1-74128-249-8 ](http://petajakarta.org/banjir/en/research/)

### Tables
#### CogniCity Schema v3.0
| Table Name | Description |
| ---------- | ----------- |
| all_reports | Confirmed reports of flooding from all data sources |
| instance_regions | Regions where CogniCity is currently deployed |
| local_areas | Neighbourhood scale unit areas, in Indonesia these are RWs |
| rem_status | Flood state of local_areas as defined by the Risk Evaluation Matrix |
| rem_status | Log changes to rem_status |

#### Data
***To do***

#### Sample Data Licenses
<dl>Jakarta's municipal boundaries are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>. <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/80x15.png" /></a></dl>

<dl>Hydrological Infrastructure Data (pumps, floodgates, waterways) is licensed under <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>. <img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/80x15.png"/></a>
</dl>
* Hydrological data are available from [Research Data Australia](https://researchdata.ands.org.au/petajakartaorg/552178) (Australian National Data Service), with DOIs held by the National Library of Australia.

### Dependencies
* [PostgreSQL](http://www.postgresql.org) version 9.4 or later, with
* [PostGIS](http://postgis.net) version 2.0 or later

### Installation
* The PostgreSQL database server must be running with a UTF-8 character set.

#### Installing the schema and data
```sh
$ build/run.sh
```
This will create a database "cognicity", build the empty schema and insert any available data.

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
```sh
$ npm install
$ npm test
```

### License
The schema is released under the GPLv3 License. See License.txt for details.
