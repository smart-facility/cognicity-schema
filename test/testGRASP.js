const test = require('unit.js');

export default (db, instance) => {
  // Cards endpoint
  describe('GRASP functionality tests: ' + instance.name, () => {
    let cardPkey; // Global card pkey object as created by database
    let reportFkey; // Global report foreign key as created by reports table
    let reportPkey; // Global report pkey as created by database
    let cardId; // Global card id object created by database

    before('Insert dummy GRASP data', (done) => {
    // Insert test data
    let query = `INSERT INTO grasp.cards (username, network, language, received)
    VALUES ('user', 'test network', 'en', True) RETURNING pkey, card_id`;

    db.oneOrNone(query)
      .then((data) => {
        cardPkey = data.pkey;
        cardId = data.card_id;

        // Insert test data
        query = `INSERT INTO grasp.reports (card_id, created_at, disaster_type,
          text, card_data, image_url, status, the_geom) VALUES ($4, now(),
          'flood', 'report text', $1, 'no_url', 'confirmed',
          ST_GeomFromText('POINT($2 $3)', 4326))
          RETURNING pkey`;

        let values = [instance.test_card_data, instance.test_report_lon,
          instance.test_report_lat, cardId];

        db.oneOrNone(query, values)
          .then((data) => {
            reportFkey = data.pkey;
            
            done();
          })
          .catch((error) => console.log(error));
        })
      .catch((error) => console.log(error));
    });

    // Test
    it('Correctly pushes the report to the cognicity.all_reports table',
      (done) => {
      // Check the test data has been assigned correct polygon
      let query = `SELECT * FROM cognicity.all_reports WHERE fkey = $1
                  AND source = 'grasp'`;
      let values = [reportFkey];
      db.any(query, values)
        .then((data) => {
          test.value(data.length).is(1);
          test.value(data[0].tags.disaster_type)
            .is(instance.test_disaster_type);
          test.value(data[0].text).is(instance.test_report_text);
          test.value(data[0].lang).is(instance.test_report_lang);
          test.value(data[0].url).is(cardId);
          test.value(data[0].report_data.water_depth)
            .is(instance.test_card_data.water_depth);
          test.value(data[0].tags.instance_region_code)
            .is(instance.test_instance_region_code);
          test.value(data[0].tags.local_area_id)
            .is(instance.test_local_area_id);
          reportPkey = data[0].pkey;
          done();
        })
        .catch((error) => test.fail(error));
    });

    // Clean up

    after('Remove dummy grasp report data', (done) => {
      // Remove dummy report
      let query = 'DELETE FROM grasp.reports WHERE pkey = $1';
      let values = [reportFkey];
      db.none(query, values)
        .catch((error) => console.log(error));

      query = 'DELETE FROM grasp.cards WHERE pkey = $1';
      values = [cardPkey];
      db.none(query, values)
        .catch((error) => console.log(error));

      query = 'DELETE FROM cognicity.all_reports WHERE pkey = $1';
      values = [reportPkey];
      db.none(query, values)
        .then(() => done())
        .catch((error) => console.log(error));
   });
});
};
