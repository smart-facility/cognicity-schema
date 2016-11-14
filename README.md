CogniCity
===========
**Open Source GeoSocial Intelligence Framework**

#### cognicity-schema: PostgreSQL/PostGIS Schema for CogniCity data.
[![Build Status](https://travis-ci.org/urbanriskmap/cognicity-schema.svg?branch=master)](https://travis-ci.org/urbanriskmap/cognicity-schema)

DOI for current stable release [v2.0.0](https://github.com/smart-facility/cognicity-schema/releases/tag/v2.0.0): [![DOI](https://zenodo.org/badge/19201/smart-facility/cognicity-schema.svg)](https://zenodo.org/badge/latestdoi/19201/smart-facility/cognicity-schema)

### About
CogniCity-schema is the PostgreSQL/PostGIS database schema for the CogniCity Framework.  The schema contains the tables required for data input by [cognicity-reports](https://github.com/smart-facility/cognicity-reports-powertrack) and data output using [cognicity-server](https://github.com/smart-facility/cognicity-server).

For a comprehensive overview of CogniCity, including the database schema see Chapter 2 of:
> "White Paper - PetaJakarta.org:
Assessing the Role of Social Media for Civic Co‑Management During Monsoon Flooding
in Jakarta, Indonesia", 2014. Holderness T & Turpin E. [ISBN 978-1-74128-249-8 ](http://petajakarta.org/banjir/en/research/)

### Tables
#### Base Schema
| Table Name | Description |
| ---------- | ----------- |
| tweet_reports | Confirmed tweet reports of flooding |
| tweet_reports_unconfirmed | Unconfirmed tweet reports of flooding |
| nonsptial_tweet_reports | Confirmed tweet reports of flooding missing geolocation metadata |
| all_users | Encrypted hash of all related Twitter usernames |
| tweet_users | Encrypted hash of user names who have submitted confirmed reports |
| tweet_invitees | Encrypted hash of users have been been sent an invitation |
| nonspatial_tweet_users | Encrypted hash of users who have submitted confirmed reports missing geolocation metadata |

#### Sample Data
The following tables are also included as samples of ancillary data used for map overlays and report aggregation, as part of the [PetaJakarta.org](http://petajakarta.org) project. SQL files for these tables and included data can be found in the `sample_data` folder.

| Table Name | Description |
| ---------- | ----------- |
| jkt_city_boundary | Boundaries of Jakarta’s five municipalities |
| jkt_subdistrict_boundary | Boundaries of Jakarta’s municipal sub-districts (‘Kecamatan’) |
| jkt_village_boundary | Boundaries of Jakarta’s municipal villages (‘Kelurahan’) |
| jkt_rw_boundary | Municipal boundaries of Jakarta’s municipal RW districts (‘Rukun-Warga’) |
| pumps | Locations of water pumps in Jakarta |
| floodgates | Locations of floodgates in Jakarta |
| waterways | Locations of waterways in Jakarta |

#### Sample Data Licenses
<dl>Jakarta's municipal boundaries are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>. <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/80x15.png" /></a></dl>

<dl>Hydrological Infrastructure Data (pumps, floodgates, waterways) is licensed under <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>. <img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/80x15.png"/></a>
</dl>
* Hydrological data are available from [Research Data Australia](https://researchdata.ands.org.au/petajakartaorg/552178) (Australian National Data Service), with DOIs held by the National Library of Australia.

### Dependencies
* [PostgreSQL](http://www.postgresql.org) version 9.2 or later, with
* [PostGIS](http://postgis.net) version 2.0 or later

### Installation
* The PostgreSQL database server must be running with a UTF-8 character set.

#### Restoring the schema
1. Create an empty database, using `createdb.sql` for required properties (NOTE: collation must be the same as the collation of your template DB en_US by default)
2. Load the schema into the new database
```shell
psql -d cognicity -f schema.sql
```
3. Optionally, load the sample data:
```shell
for datafile in sample_data/*/*.sql
do
  psql -d cognicity -f $datafile
done
```
### License
The schema is released under the GPLv3 License. See License.txt for details.
