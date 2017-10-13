import Promise from 'bluebird';

const pgp = require('pg-promise')({
  promiseLib: Promise, // Use bluebird for enhanced Promises
});

const DATABASE = process.env['PGDATABASE'];
const COUNTRY = process.env['COUNTRY'];
console.log('Testing against ' + DATABASE + ' for ' + COUNTRY);

import testInstanceRegions from './testInstanceRegions.js';
import testTemplateReportSchema from './testTemplateReportSchema';
import testGRASP from './testGRASP';
import testDetik from './testDetik';
import testQlue from './testQlue';
import testZears from './testZears';
import testFloodgauge from './testFloodgauge';
import testREM from './testREM';
import testVersion from './testVersion';

let instances = {
  'indonesia': {
    'connection': 'postgres://postgres@localhost:5432/' + DATABASE,
    'name': 'cognicity_indonesia',
    'test_instance_region_code': 'jbd',
    'test_local_area_id': '800',
    'test_report_lat': -6.2,
    'test_report_lon': 106.816667,
    'test_report_text': 'report text',
    'test_report_lang': 'en',
    'test_report_url': 'no_url',
    'test_card_url': 'abcdefg',
    'test_card_data': {'water_depth': '100'},
  },

  'india': {
    'connection': 'postgres://postgres@localhost:5432/' + DATABASE,
    'name': 'cognicity_india',
    'test_instance_region_code': 'chn',
    'test_local_area_id': '23',
    'test_report_lat': 13.083333,
    'test_report_lon': 80.266667,
    'test_report_text': 'report text',
    'test_report_lang': 'en',
    'test_report_url': 'no_url',
    'test_card_url': 'abcdefg',
    'test_card_data': {'water_depth': '100'},
  },

  'us': {
    'connection': 'postgres://postgres@localhost:5432/' + DATABASE,
    'name': 'cognicity_us',
    'test_instance_region_code': 'brw',
    'test_local_area_id': '1', // 03A grid in Fort Lauderdale
    'test_report_lat': 26.09591,
    'test_report_lon': -80.16504,
    'test_report_text': 'report text',
    'test_report_lang': 'en',
    'test_report_url': 'no_url',
    'test_card_url': 'abcdefg',
    'test_card_data': {'water_depth': '100'},
  },
};

// Test instance configuration
let instance = instances[COUNTRY];

// Database
let db = pgp(instance.connection);

// Tests
testInstanceRegions(db, instance);
testTemplateReportSchema(db, instance);
testGRASP(db, instance);
testDetik(db, instance);
testQlue(db, instance);
testZears(db, instance);
testFloodgauge(db, instance);
testREM(db);
testVersion(db, process.env.npm_package_version);
