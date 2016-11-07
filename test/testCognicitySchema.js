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

  after ('Remove dummy data', function(){
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
