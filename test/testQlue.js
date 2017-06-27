const test = require('unit.js');

export default (db, instance) => {
  // Cards endpoint
  describe('Qlue report schema functionality', () => {

    let report_fkey;
    let report_pkey;

    before ('Insert dummy Qlue data', (done) => {

    // Insert test data
    let query = "INSERT INTO qlue.reports (post_id, created_at, disaster_type, text,  lang, image_url, title, qlue_city, the_geom) VALUES (9999, now(), 'flood', 'report text', 'en', 'no_image', 'title', 'jbd', ST_GeomFromText('POINT(106.816667 -6.2)', 4326)) RETURNING pkey";

    let values = [ instance.test_report_lon, instance.test_report_lat ]
    db.oneOrNone(query, values)
      .then((data) => {
        report_fkey = data.pkey;
        done();
      })
      .catch((error) => console.log(error));
    });

    // Test
    it ('Correctly pushes to cognicity.all_reports and defines report regions', (done) => {

      // Check the test data has been assigned correct polygon
      let query = "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'qlue'";
      let values = [ report_fkey ]
      db.any(query, values)
        .then((data) => {
          report_pkey = data[0].pkey;
          test.value(data.length).is(1);
          test.value(data[0].disaster_type).is('flood');
          test.value(data[0].text).is('report text');
          test.value(data[0].lang).is('en');
          test.value(data[0].url).is(null);
          test.value(data[0].tags.instance_region_code).is(instance.test_instance_region_code);
          test.value(data[0].tags.local_area_id).is(instance.test_local_area_id);
          done();
        })
        .catch((error) => test.fail(error));
    });

    // Clean up
    after ('Remove dummy qlue report data', (done) => {
      // Remove dummy report
      let query = "DELETE FROM qlue.reports WHERE pkey = $1";
      let values = [ report_fkey ]
      db.none(query, values)
        .catch((error) => console.log(error));

      query = "DELETE FROM cognicity.all_reports WHERE pkey = $1";
      values = [ report_pkey ]
      db.none(query, values)
        .then(() => done())
        .catch((error) => console.log(error));
     });
   });
}
