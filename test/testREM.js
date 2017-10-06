const test = require('unit.js');

export default (db) => {
  // Cards endpoint
  describe('REM schema functionality', () => {

    before ('Insert dummy REM data', (done) => {

    // Insert test data
    let query = "INSERT INTO cognicity.rem_status_log (local_area, state, username) VALUES (1, 2, 'test user')";
    // Mock floodgauge report data
    db.none(query)
      .then(() => {
        done()
      })
      .catch((error) => console.log(error));
    });

    // Test
    it ('Can get correct flood value', (done) => {

      // Check the test data can be output with rem_get_flood function
      let query = "SELECT row_to_json((cognicity.rem_get_flood(now()))) as output";
      db.any(query)
        .then((data) => {
          test.value(data.length).is(1);
          test.value(data[0].output.local_area).is(1);
          test.value(data[0].output.state).is(2);
          done();
        })
        .catch((error) => test.fail(error));

      // Change sample data
      query = "INSERT INTO cognicity.rem_status_log (local_area, state, username) VALUES (1, 1, 'test user')"
      db.none(query)
        .then(() => {
        })
        .catch((error) => test.fail(error));

      // Check that cognicity.get_max_flood works
      query = "SELECT row_to_json((cognicity.rem_get_max_flood(now() - interval '10 minutes', now()))) as output";
      db.any(query)
        .then((data) => {
          test.value(data.length).is(1);
          test.value(data[0].output.local_area).is(1);
          test.value(data[0].output.state).is(2);
          done();
        })
        .catch((error) => test.fail(error));

    });

    // Clean up
    after ('Remove dummy flood report data', (done) => {
      // Remove dummy report
      let query = "DELETE FROM cognicity.rem_status WHERE local_area = 1";
      db.none(query)
      .then(() => done())
        .catch((error) => console.log(error));
     });
   });
}
