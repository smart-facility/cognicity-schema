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
        text: "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'data_source';",
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
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query(queryObject, function(err, result){
          pgDone();
          done();
        });
      });
    });
  });

  var card_key, grasp_report_key, report_key;
  describe ('GRASP Reports Schema Functions', function(){

    before ('Insert dummy data', function(done){
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query("INSERT INTO grasp.cards (card_id, username, network, language, received) VALUES ('abcdefg', 'user', 'test network', 'en', True) RETURNING pkey",
        function(err, result){
          card_key = result.rows[0].pkey;
          pgDone();
        });
      });

      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        var properties = JSON.stringify({flood_depth:100});
        client.query({text: "INSERT INTO grasp.reports (card_id, created_at, disaster_type, text, card_data, image_url, status, the_geom) VALUES ('abcdefg', now(), 'flood', 'card text', $1, 'no_url', 'confirmed', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", values:[properties]}, function(err, result){
          grasp_report_key = result.rows[0].pkey;
          pgDone();
          pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
            client.query({text: "UPDATE grasp.reports SET image_url = 'test_image_url' WHERE pkey = $1", values:[grasp_report_key]}, function(err, result){
              done();
              pgDone();
            });
          });
        });
      });
  });

    it ('Correctly pushes the report to all_reports table', function(done){
      var queryObject = {
        text: "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'grasp';",
        values: [ grasp_report_key ]
      };

      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query(queryObject, function(err, result){
          test.value(err).is(null);
          test.value(result.rows.length).is(1);
          var resultObject = result.rows[0];
          report_key = resultObject.pkey;
          test.value(resultObject.disaster_type).is('flood');
          test.value(resultObject.text).is('card text');
          test.value(resultObject.lang).is('en');
          test.value(resultObject.report_data.flood_depth).is(100);
          test.value(resultObject.url).is('data.petabencana.id/cards/abcdefg');
          test.value(resultObject.image_url).is('test_image_url');
          done();
          pgDone();
        });
      });
    });

    it ('Correctly issues a notify when card received status is set to true', function(done){
      var queryObject = {
        text: "UPDATE grasp.cards SET received = $1 WHERE card_id = 'abcdefg';",
        values: [ true ]
      };

      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.on('notification', function(msg){
          // Get a pg notify object, parse and test known values
          var result = JSON.parse(msg.payload);
          test.value(result.cards.username).is('user');
          test.value(result.cards.network).is('test network');
          test.value(result.cards.language).is('en');
          test.value(result.cards.report_impl_area).is('jbd');
          done();
          pgDone();
        });
      client.query("LISTEN watchers");
      });

      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        // Update cards table to trigger pg notify (see above)
        client.query(queryObject, function(err, result){
          pgDone();
        });
      });
    });

    after ('Remove dummy data', function(done){

      var queryObject1 = {
        text: "DELETE FROM grasp.reports WHERE pkey = $1;",
        values: [ grasp_report_key ]
      };

      var queryObject2 = {
        text: "DELETE FROM grasp.cards WHERE pkey = $1 ;",
        values: [ card_key ]
      };

      var queryObject3 = {
        text: "DELETE FROM cognicity.all_reports WHERE pkey = $1;",
        values: [ report_key ]
      };

      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query(queryObject1, function(err, result){
          client.query(queryObject2, function(err, result){
            client.query(queryObject3, function(err, result){
              pgDone();
              done();
            })
          })
        });
      });
    });
  });
  // Detik tests
  var report_id, report_key;
  describe ('Detik Reports Schema Functions', function(){

    before ('Insert dummy data', function(done){
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query("INSERT INTO detik.reports (contribution_id, created_at, disaster_type, text,  lang, url, image_url, title, the_geom) VALUES (9999, now(), 'flood', 'report text', 'en', 'no_url', 'no_image', 'title', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", function(err, result){
          report_id = result.rows[0].pkey;
          done();
          pgDone();
        });
      });
    });

    it ('Correctly pushes the report to all_reports table', function(done){

      var queryObject = {
        text: "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'detik';",
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
        text: "DELETE FROM detik.reports WHERE pkey = $1;",
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
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query(queryObject, function(err, result){
          pgDone();
          done();
        });
      });
    });
  });
  // Qlue tests
  var report_id, report_key;
  describe ('Qlue Reports Schema Functions', function(){

    before ('Insert dummy data', function(done){
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query("INSERT INTO qlue.reports (post_id, created_at, disaster_type, text, lang, image_url, title, qlue_city, the_geom) VALUES (9999, now(), 'flood', 'report text', 'en', 'no_image', 'title', 'jabodetabek', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", function(err, result){
          report_id = result.rows[0].pkey;
          done();
          pgDone();
        });
      });
    });

    it ('Correctly pushes the report to all_reports table', function(done){

      var queryObject = {
        text: "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'qlue';",
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
          done();
          pgDone();
        });
      });
    });

    after ('Remove dummy data', function(done){
      var queryObject = {
        text: "DELETE FROM qlue.reports WHERE pkey = $1;",
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
      pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
        client.query(queryObject, function(err, result){
          pgDone();
          done();
        });
      });
    });
  });
});

describe ('Floodgauge Schema Functions', function(){

  var reportid;
  before ('Insert dummy data', function(done){
    pg.connect(PG_CONFIG_STRING, function(err, client, pgDone){
      client.query("INSERT INTO floodgauge.reports (gaugeID, measureDateTime, depth, deviceID, reportType, level, notificationFlag, gaugeNameId, gaugeNameEn, gaugeNameJp, warningLevel, warningNameId, warningNameEn, warningNameJp, observation_comment, the_geom) VALUES ('1', now(), 100, '1', 'confirmed', '100', 0, 'gauge', 'gauge', 'gauge', 4, 'warningname', 'warningname', 'warningname', 'comment', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey", function(err, result){
        reportid = result.rows[0].pkey;
        done();
        pgDone();
      });
    });
  });

  it ('Correctly defines report regions', function(done){

    var queryObject = {
      text: "SELECT * FROM floodgauge.reports WHERE pkey = $1;",
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
      text: "DELETE FROM floodgauge.reports WHERE pkey = $1;",
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
