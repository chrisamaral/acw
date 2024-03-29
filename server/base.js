"use strict";
require('debug');
var resources;

function setVariables() {
    var fs = require('fs');
    this.dbConfig = require('./config/db.js');
    this.ENV = fs.existsSync('./config/development') ? 'development' : 'production';
    this.httpProtocol = 'http';
    this.DOMAIN = this.ENV === 'production' ? 'acwautosis.info' : 'acw.dev';
    this.dbConfig.multipleStatements = (this.ENV === 'development');

    console.log("ENVIROMENT: " + this.ENV);
    console.log("DOMAIN: " + this.DOMAIN);
}
function Base(mysql) {
    setVariables.call(this);
    this.waitTime = 2;
    this.mysql = mysql;
}

Base.prototype.handleDbError = function (err) {
    setTimeout(this.startConnection.bind(this), this.waitTime * 1000);
    console.log('error when connecting to db:', err.code, 'will try again in', this.waitTime, 'seconds');
};

Base.prototype.startConnection = function () {
    console.log('connecting to db...');
    this.db = this.mysql.createConnection(this.dbConfig);

    this.db.connect(function (err) {
        if (!err) {
            console.log('... connected!');
        } else {
            this.handleDbError(err);
        }
    }.bind(this));

    this.db.on('error', function (err) {
        console.log('generic db error handler', err);
        if (!err.fatal) {
            return;
        }

        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            this.handleDbError(err);
        } else {
            throw err;
        }

    }.bind(this));
};

module.exports = function (mysql) {
    var Db;
    if (mysql) {
        resources = new Base(mysql);
        resources.helpers = require('./helpers/std.js');

        Db = require('mysql-activerecord');
        resources.pool = new Db.Pool(require('./config/active.db.js'));
        resources.strftime = require('strftime');
        resources.startConnection();
        resources.panic = function (msg) {
            console.error(msg);
            proccess.exit();
        }
    }
    return resources;
};

