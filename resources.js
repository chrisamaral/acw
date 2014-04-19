"use strict";
require('debug');
var resources;

function Resources (mysql) {
    var fs = require('fs');
    this.dbConfig = require('./config/db.js');
    this.httpProtocol = 'http';
    this.DOMAIN = 'acwautosis.info';
    this.ENV = (fs.existsSync('./config/development'))?'development':'production';
    this.waitTime = 2;

    this.mysql = mysql;
    console.log("ENVIROMENT: " + this.ENV);
    console.log("DOMAINNAME: " + this.DOMAIN);
}
Resources.prototype.handleDbError = function (err) {
    this.db.connAlive = false;
    setTimeout(this.startConnection.bind(this), this.waitTime * 1000);
    console.log('error when connecting to db:', err.code, 'will try again in', this.waitTime, 'seconds');
};
Resources.prototype.startConnection = function(){
    console.log('connecting to db...');
    this.db = this.mysql.createConnection(this.dbConfig);
    this.db.connAlive = false;

    this.db.connect(function (err) {
        if (!err) {
            this.db.connAlive = true;
            console.log('... connected!');
        }else{
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
    if (mysql) {
        resources = new Resources(mysql);
        resources.startConnection();
    }
    return resources;
};
