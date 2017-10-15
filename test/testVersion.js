const test = require('unit.js');

export default (db, version) => {
  // Cards endpoint
  describe('Schema version functionality', () => {
    // Test
    it('Can get correct version', (done) => {
      // Check the test data can be output with rem_get_flood function
      let query = 'SELECT * FROM cognicity.version()';
      db.oneOrNone(query)
        .then((data) => {
          test.value(data.version).is(version);
          done();
        })
        .catch((error) => test.fail(error));
   });
});
};
