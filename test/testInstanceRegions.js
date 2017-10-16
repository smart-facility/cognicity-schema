const test = require('unit.js');

export default (db, instance) => {
  // Cards endpoint
  describe('Instance Region Functionality: ' + instance.name, () => {
    let reportPkey;

    before('Insert dummy test report data', (done) => {
    // Insert test data
    let query = `INSERT INTO cognicity.all_reports
    (fkey, created_at, text, source, status, disaster_type, lang, url,
      image_url, title, the_geom)
      VALUES (1, now(), 'test report', 'testing', 'confirmed', 'flood',
      'en', 'no_url', 'no_url', 'no_title',
      ST_GeomFromText('POINT($1 $2)',4326))
      RETURNING pkey`;

    let values = [instance.test_report_lon, instance.test_report_lat];
    db.oneOrNone(query, values)
      .then((data) => {
        reportPkey = data.pkey;
        done();
      })
      .catch((error) => console.log(error));
    });

    // Test
    it('Correctly defines report regions', (done) => {
      // Check the test data has been assigned correct polygon
      let query = 'SELECT * FROM cognicity.all_reports WHERE pkey = $1';
      let values = [reportPkey];
      db.any(query, values)
        .then((data) => {
          test.value(data[0].tags.instance_region_code)
            .is(instance.test_instance_region_code);
          test.value(data[0].tags.local_area_id)
            .is(instance.test_local_area_id);
          done();
        })
        .catch((error) => test.fail(error));
    });

    // Clean up
    after('Remove dummy instance regions test report data', (done) => {
      // Remove dummy report
      let query = 'DELETE FROM cognicity.all_reports WHERE pkey = $1';
      let values = [reportPkey];
      db.none(query, values)
        .then(() => done())
        .catch((error) => console.log(error));
    });
   });
};
