const test = require('unit.js');

export default (db, instance) => {
  // Cards endpoint
  describe('Floodgauge report schema functionality', () => {

    let report_pkey;

    before ('Insert dummy floodgauge data', (done) => {

    // Insert test data
    let query = "INSERT INTO floodgauge.reports (gaugeID, measureDateTime, depth, deviceID, reportType, level, notificationFlag, gaugeNameId, gaugeNameEn, gaugeNameJp, warningLevel, warningNameId, warningNameEn, warningNameJp, observation_comment, the_geom) VALUES ('1', now(), 100, '1', 'confirmed', '100', 0, 'gauge', 'gauge', 'gauge', 4, 'warningname', 'warningname', 'warningname', 'comment', ST_GeomFromText('POINT($1 $2)', 4326)) RETURNING pkey";

    // Mock floodgauge report data
    let values = [ instance.test_report_lon, instance.test_report_lat ]
    db.oneOrNone(query, values)
      .then((data) => {
        report_pkey = data.pkey;
        done();
      })
      .catch((error) => console.log(error));
    });

    // Test
    it ('Correctly defines report regions', (done) => {

      // Check the test data has been assigned correct polygon
      let query = "SELECT * FROM floodgauge.reports WHERE pkey = $1";
      let values = [ report_pkey ]
      db.any(query, values)
        .then((data) => {
          report_pkey = data[0].pkey;
          test.value(data.length).is(1);
          test.value(data[0].gaugeid).is('1');
          test.value(data[0].depth).is(100);
          test.value(data[0].deviceid).is('1');
          test.value(data[0].reporttype).is('confirmed');
          test.value(data[0].level).is(100);
          test.value(data[0].notificationflag).is(0);
          test.value(data[0].gaugenameid).is('gauge');
          test.value(data[0].gaugenameen).is('gauge');
          test.value(data[0].gaugenamejp).is('gauge');
          test.value(data[0].warninglevel).is(4);
          test.value(data[0].warningnameid).is('warningname');
          test.value(data[0].warningnameen).is('warningname');
          test.value(data[0].warningnamejp).is('warningname');
          test.value(data[0].observation_comment).is('comment');
          test.value(data[0].tags.instance_region_code).is(instance.test_instance_region_code);
          test.value(data[0].tags.local_area_id).is(instance.test_local_area_id);
          done();
        })
        .catch((error) => test.fail(error));
    });

    // Clean up
    after ('Remove dummy floodgauge report data', (done) => {
      // Remove dummy report
      let query = "DELETE FROM floodgauge.reports WHERE pkey = $1";
      let values = [ report_pkey ]
      db.none(query, values)
      .then(() => done())
        .catch((error) => console.log(error));
     });
   });
}
