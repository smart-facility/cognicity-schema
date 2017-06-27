import Promise from 'bluebird';

const pgp = require('pg-promise')({
  promiseLib: Promise // Use bluebird for enhanced Promises
});

import testInstanceRegions from './testInstanceRegions.js';
import testTemplateReportSchema from './testTemplateReportSchema';
import testGRASP from './testGRASP';

let instances = [
  {
    "connection": "postgres://postgres@localhost:5432/cognicity_indonesia",
    "name":"cognicity_indonesia",
    "test_instance_region_code": "jbd",
    "test_local_area_id":"800",
    "test_report_lat": -6.2,
    "test_report_lon": 106.816667,
    "test_report_text": "report text",
    "test_report_lang": "en",
    "test_report_url": "no_url",
    "test_card_url": "abcdefg",
    "test_card_data": { "water_depth": "100" } //TODO-check this
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
  testTemplateReportSchema(db, instance)
  testGRASP(db, instance)

}
