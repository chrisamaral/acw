"use strict";
var mysql = require('mysql'),
    etc = require('./app.js')(mysql);


require('./controllers/main.js');