const argv = require('./argv');
require('dotenv').config();
module.exports = parseInt(
  argv.port || process.env.REACT_APP_PORT || '3002',
  10,
);
