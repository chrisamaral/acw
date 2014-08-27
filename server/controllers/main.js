"use strict";
var etc = require('../base.js')();

var express = require('express'),
    connetFlash = require('connect-flash'),
    bodyParser = require('body-parser'),
    cookieParser = require('cookie-parser'),
    expressSession = require('express-session'),
    RedisStore = require('connect-redis')(expressSession),

    _ = require('lodash'),
    http = require('http'),

    sessMaxAge = 1000 * 60 * 60 * 24,
    customAuth,
    path = require('path'),
    pub_dir = path.normalize(__dirname + "/../..") + '/public';

etc.sessionStore = new RedisStore();
etc.express = express();

etc.express.set('json spaces', 2);
etc.express.use(express.static(pub_dir));

etc.express.use(bodyParser.urlencoded({limit: '5mb', extended: true}));
etc.express.use(bodyParser.json({limit: '5mb', extended: true}));

etc.express.use(cookieParser());

etc.express.use(expressSession({
    saveUninitialized: true,
    resave: true,
    secret: 'maiorsegredodomundo',
    key: 'acw.sid',
    cookie: {
        maxAge: sessMaxAge,
        domain: '.' + etc.DOMAIN
    },
    store: etc.sessionStore
}));

/*
 middleware fix for
 >> https://github.com/strongloop/express/issues/2269
 until
 >> https://github.com/admittedly/express/commit/ed6d0e3819a2e7fe6f2052b4e223e57435c4fdc3
 gets released
 */

etc.express.use(function (req, res, next) {

    var resSend = res.send;

    res.send = function () {
        var statusNumber;

        if (_.isNumber(arguments[0])) {
            statusNumber = arguments[0];
            return res.status(statusNumber).end(http.STATUS_CODES[statusNumber]);
        }

        resSend.apply(res, arguments);
    };

    next();
});

etc.express.use(connetFlash());
etc.express.set('view engine', 'jade');

customAuth = require('./auth.js');
customAuth.init(function () {

    etc.express.get('/', function (req, res) {
        etc.helpers.serveIt('front', '/',  req, res);
    });

    // adicionar rotas de login
    customAuth.listen();

    require('./home.js');
    require('./user.js');
    require('./admin.js');
    if (etc.ENV === 'development') {
        require('../hacks/admin.js');
    }
    etc.express.use(function (req, res, next) {

        if (req.xhr) {
            return res.send(404);
        }

        res.status(404);
        res.render('errors/404');
    });

    etc.express.use(function (err, req, res, next) {

        if (err && err instanceof etc.authorized.UnauthorizedError === false) {
            return res.status(500).render('errors/500');
        }

        if (!req.isAuthenticated()) {
            req.session.redirect_to = req.originalUrl;
            if (req.xhr) {
                return res.send(401);
            }
            return res.status(401).redirect('/login');
        }

        if (req.xhr) {
            return res.send(403);
        }

        res.status(403).render('errors/403');
    });

    etc.express.listen(4000);
});

