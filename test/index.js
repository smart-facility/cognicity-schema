import Promise from 'bluebird';

const test = require('unit.js');
const pgp = require('pg-promise')({
  promiseLib: Promise // Use bluebird for enhanced Promises
});

import testInstanceRegions from './testInstanceRegions.js';


let instances = [
  {
    "connection": "postgres://postgres@localhost:5432/cognicity_indonesia",
    "name":"cognicity_indonesia",
    "test_instance_region_code": "jbd",
    "test_local_area_id":"800",
    "test_report_lat": -6.2,
    "test_report_lon": 106.816667

  }
]




//[, 'postgres://postgres@localhost:5432/cognicity-india']

for (let i = instances.length; i--;){

  // Test instance configuration
  let instance = instances[i]

  // Database
  let db = pgp(instance.connection)

  // Tests
  testInstanceRegions(db, instance)

}
