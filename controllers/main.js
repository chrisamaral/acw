"use strict";
var etc = require('../app.js')();

var express = require('express'),
    connetFlash = require('connect-flash'),
    bodyParser = require('body-parser'),
    cookieParser = require('cookie-parser'),
    expressSession = require('express-session'),
    XSession = require('../lib/xsession.js')(expressSession),
    sessMaxAge = 1000 * 60 * 60 * 24,
    customAuth;

etc.express = express();
etc.passport = require('passport');
etc.express.use(express.static(__dirname + '/public'));
etc.express.use(bodyParser());
etc.express.use(cookieParser());
etc.express.use(expressSession({
    secret: 'maiorsegredodomundo',
    key: 'acw.sid',
    cookie: { maxAge: sessMaxAge },
    store: new XSession()
}));

etc.express.use(connetFlash());
etc.express.set('view engine', 'jade');

customAuth = require('./auth.js');
customAuth.init();

etc.express.get('/', function (req, res) {
    etc.helpers.serveIt('home', '/',  req, res);
});

// adicionar rotas de login
customAuth.listen();
require('./user.js');
etc.express.listen(4000);