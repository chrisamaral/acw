var db = require('./db.js');

module.exports = {
    server: 'localhost',
    database: db.database,
    username: db.user,
    password: db.password
};
