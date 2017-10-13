const test = require('unit.js');

export default (db, instance) => {
  // Cards endpoint
  describe('Template report data source functionality: ' + instance.name, () => {

    let report_pkey; // Global report pkey object as created by database
    let report_fkey; // Global report foreign key object as created by database in reports table

    before ('Insert dummy data', (done) => {

    // Insert test data
    let query = "INSERT INTO template_data_source.reports (created_at, disaster_type, text,  lang, url, the_geom) VALUES (now(), 'flood', 'report text', 'en', 'no_url', ST_GeomFromText('POINT($1 $2)', 4326)) RETURNING pkey";

    let values = [ instance.test_report_lon, instance.test_report_lat ]

    db.oneOrNone(query, values)
      .then((data) => {
        report_fkey = data.pkey;
        done();
      })
      .catch((error) => {
        test.fail(error)
      })
    });

    // Test
    it ('Correctly pushes the report to the cognicity.all_reports table', (done) => {

      // Check the test data has been assigned correct polygon
      let query = "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'data_source'";
      let values = [ report_fkey ]
      db.any(query, values)
        .then((data) => {
          test.value(data.length).is(1);
          test.value(data[0].tags.disaster_type).is(instance.test_disaster_type);
          test.value(data[0].text).is(instance.test_report_text);
          test.value(data[0].lang).is(instance.test_report_lang);
          test.value(data[0].url).is(instance.test_report_url);
          report_pkey = data[0].pkey;
          done();
        })
        .catch((error) => console.log(error));
    });

    // Clean up
    after ('Remove dummy template report data', (done) => {

      // Remove dummy report
      let query = "DELETE FROM template_data_source.reports WHERE pkey = $1";
      let values = [ report_fkey ]
      db.none(query, values)
        .catch((error) => console.log(error));

      query = "DELETE FROM template_data_source.reports WHERE pkey = $1";
      values = [ report_pkey ]
      db.none(query, values)
        .then(() => done())
        .catch((error) => console.log(error));
    });
   });
}
