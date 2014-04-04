"use strict";
require('debug');
var dbConfig = require('./config/db.js');
var resources;
var os = require("os");

function Resources(mysql) {
    var self = this;

    self.httpProtocol = 'http';
    self.DOMAIN = 'acwautosis.info';
    self.ENV = 'prod';

    if (os.hostname().indexOf('chris') > -1) {
        self.DOMAIN = 'acw.dev';
        self.ENV = 'dev';
    }

    console.log("ENVIROMENT: " + self.ENV);
    console.log("DOMAINNAME: " + self.DOMAIN);

    function handleDisconnect() {
        console.log('connecting to db...');
        self.db = mysql.createConnection(dbConfig);

        self.db.connect(function (err) {
            if (err) {
                console.log('error when connecting to db:', err);
                setTimeout(handleDisconnect, 2000);
            } else {
                console.log('... connected!');
            }
        });

        var errorHandler = function (err) {

            if (!err.fatal) {
                return;
            }

            console.log('db error', err);
            if (err.code === 'PROTOCOL_CONNECTION_LOST') {
                handleDisconnect();
            } else {
                throw err;
            }
        };

        self.db.on('error', errorHandler);
    }
    handleDisconnect();
    return this;
}

module.exports = function (mysql) {
    if (mysql) {
        resources = new Resources(mysql);
    }
    return resources;
};
