"use strict";
var etc = require('../app.js')();

var express = require('express'),
    connetFlash = require('connect-flash'),
    bodyParser = require('body-parser'),
    cookieParser = require('cookie-parser'),
    expressSession = require('express-session'),
    XSession = require('../lib/xsession.js')(expressSession),
    sessMaxAge = 1000 * 60 * 60 * 24,
    customAuth,
    path = require('path'),
    pub_dir = path.normalize(__dirname + "/..") + '/public';

etc.express = express();
etc.express.use(express.static(pub_dir));
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
customAuth.init(function () {

    etc.express.get('/', function (req, res) {
        etc.helpers.serveIt('home', '/',  req, res);
    });

    // adicionar rotas de login
    customAuth.listen();
    require('./user.js');
    require('./admin.js');

    etc.express.use(function (req, res, next) {
        res.status(404);
        res.render('errors/404');
    });

    etc.express.use(function (err, req, res, next) {
        console.log(err);
        if (err && err instanceof etc.authorized.UnauthorizedError === false) {
            res.status(500);
            return res.render('errors/500');
        }

        res.status(401);

        if (!req.isAuthenticated()) {
            req.session.redirect_to = req.originalUrl;
            return res.redirect('/login');
        }

        if (req.xhr) {
            return res.send(401);
        }

        res.render('errors/401');
    });

    etc.express.listen(4000);
});

