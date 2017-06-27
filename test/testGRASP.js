const test = require('unit.js');

export default function (db, instance){
  // Cards endpoint
  describe('GRASP functionality tests', () => {

    let card_pkey; // Global card pkey object as created by database
    let report_fkey; // Global report foreign key object as created by database in reports table
    let report_pkey; // Global report pkey object as created by database

    before ('Insert dummy GRASP data', (done) => {

    // Insert test data
    let query = "INSERT INTO grasp.cards (card_id, username, network, language, received) VALUES ('abcdefg', 'user', 'test network', 'en', True) RETURNING pkey";

    db.oneOrNone(query)
      .then((data) => card_pkey = data.pkey)
      .catch((error) => console.log(error));

    // Insert test data
    query = "INSERT INTO grasp.reports (card_id, created_at, disaster_type, text, card_data, image_url, status, the_geom) VALUES ('abcdefg', now(), 'flood', 'report text', $1, 'no_url', 'confirmed', ST_GeomFromText('POINT($2 $3)', 4326)) RETURNING pkey";

    let values = [ instance.test_card_data, instance.test_report_lon, instance.test_report_lat ];

    db.oneOrNone(query, values)
      .then((data) => {
        report_fkey = data.pkey;
        done();
      })
      .catch((error) => console.log(error));
    });

    // Test
    it ('Correctly pushes the report to the cognicity.all_reports table', (done) => {
      // Check the test data has been assigned correct polygon
      let query = "SELECT * FROM cognicity.all_reports WHERE fkey = $1 AND source = 'grasp'";
      let values = [ report_fkey ]
      db.any(query, values)
        .then((data) => {
          test.value(data.length).is(1);
          test.value(data[0].tags.disaster_type).is(instance.test_disaster_type);
          test.value(data[0].text).is(instance.test_report_text);
          test.value(data[0].lang).is(instance.test_report_lang);
          test.value(data[0].url).is(instance.test_card_url);
          test.value(data[0].report_data.water_depth).is(instance.test_card_data.water_depth);

          report_pkey = data[0].pkey;
          done();
        })
        .catch((error) => test.fail(error));
    });

    // Clean up

    after ('Remove dummy template report data', (done) => {
      // Remove dummy report
      let query = "DELETE FROM grasp.reports WHERE pkey = $1";
      let values = [ report_fkey ]
      db.none(query, values)
        .catch((error) => console.log(error));

      query = "DELETE FROM grasp.cards WHERE pkey = $1";
      values = [ card_pkey ]
      db.none(query, values)
        .catch((error) => console.log(error));

      query = "DELETE FROM cognicity.all_reports WHERE pkey = $1";
      values = [ report_pkey ]
      db.none(query, values)
        .then(() => done())
        .catch((error) => console.log(error));
   });
})
}
