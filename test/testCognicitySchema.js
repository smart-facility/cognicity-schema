'use strict';

var test = require('unit.js');
var pg = require('pg');
var PG_CONFIG_STRING = 'postgres://postgres@localhost:5432/cognicity'

describe ('CogniCity Schema Functions', function(){

  var reportid;
  before ('Insert dummy data', function(done){
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query("INSERT INTO cognicity.all_reports (fkey, created_at, text, source, status, disaster_type, lang, url, image_url, title, the_geom) VALUES (1, now(), 'test report', 'testing', 'confirmed', 'flood', 'en', 'no_url', 'no_url', 'no_title', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", function(err, result){
        reportid = result.rows[0].pkey;
        done();
        pgDone();
      });
    });
  });

  it ('Correctly defines report regions', function(done){

    var queryObject = {
      text: "SELECT * FROM cognicity.all_reports WHERE pkey = $1;",
      values: [ reportid ]
    };

    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query(queryObject, function(err, result){
        test.value(err).is(null);
        test.value(result.rows.length).is(1);
        var resultObject = result.rows[0];
        test.value(resultObject.tags.instance_region_code).is('jbd');
        test.value(resultObject.tags.local_area_id).is('800');
        done();
        pgDone();
      });
    });
  });

  after ('Remove dummy data', function(done){
    var queryObject = {
      text: "DELETE FROM cognicity.all_reports WHERE pkey = $1;",
      values: [ reportid ]
    };
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query(queryObject, function(err, result){
        done();
        pgDone();
      });
    });
  });
});

var report_id, report_key;
describe ('Template Reports Schema Functions', function(){

  before ('Insert dummy data', function(done){
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query("INSERT INTO template_data_source.reports (created_at, disaster_type, text,  lang, url, the_geom) VALUES (now(), 'flood', 'report text', 'en', 'no_url', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", function(err, result){
        report_id = result.rows[0].pkey;
        done();
        pgDone();
      });
    });
  });

  it ('Correctly pushes the report to all_reports table', function(done){

    var queryObject = {
      text: "SELECT * FROM cognicity.all_reports WHERE fkey = $1;",
      values: [ report_id ]
    };

    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query(queryObject, function(err, result){
        test.value(err).is(null);
        test.value(result.rows.length).is(1);
        var resultObject = result.rows[0];
        report_key = resultObject.pkey;
        test.value(resultObject.disaster_type).is('flood');
        test.value(resultObject.text).is('report text');
        test.value(resultObject.lang).is('en');
        test.value(resultObject.url).is('no_url');
        done();
        pgDone();
      });
    });
  });

  after ('Remove dummy data', function(done){
    var queryObject = {
      text: "DELETE FROM template_data_source.reports WHERE pkey = $1;",
      values: [ report_id ]
    };
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query(queryObject, function(err, result){
        pgDone();
      });
    });
    queryObject = {
      text: "DELETE FROM cognicity.all_reports WHERE pkey = $1;",
      values: [ report_key ]
    };
    console.log(report_key);
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query(queryObject, function(err, result){
        pgDone();
        done();
      });
    });
  });
});
