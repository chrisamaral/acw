"use strict";

var bcrypt = require('bcrypt');
var _ = require('lodash');
var mysql = require('mysql');
var etc = require('./resources.js')(mysql);
var pageDeps = require('./config/pageDependencies.js');
var helpers = require('./helpers/std.js');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var expressSession = require('express-session');

var XSession = require('./lib/xsession.js')(expressSession);
var connetFlash = require('connect-flash');

var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy,
    GoogleStrategy = require('passport-google').Strategy,
    YahooStrategy = require('passport-yahoo').Strategy;

passport.use(new LocalStrategy({usernameField: 'email'}, function (email, password, done) {
    etc.db.query('SELECT user.id, user.short_name, user.full_name, user.avatar, user.password ' +
        ' FROM  acw.user_email ' +
        ' JOIN acw.user ON user.id = user_email.user ' +
        ' WHERE user_email.email = ? AND user.activated = 1 AND user.password IS NOT NULL ',
        [email],
        function (err, rows) {
            if (err) {
                return done(err);
            }
            if (rows.length) {
                var user = rows[0];
                bcrypt.compare(password, user.password, function (err, res) {
                    if (err) {
                        return done(err);
                    }

                    if (res) {
                        delete user.password;
                        return done(null, user);
                    }

                    return done(null, false, {message: 'Senha incorreta.'});
                });
            } else {
                return done(null, false, {message: 'Email não cadastrado.'});
            }
        });
}));

function extEmailLogin (identifier, profile, done) {
    if (!profile || !profile.emails) {
        return done(null, false, {message: 'Falha no login'});
    }

    var emails = [];
    profile.emails.forEach(function (email) {
        emails.push(email.value);
    });

    etc.db.query(' SELECT user.id, user.short_name, user.full_name, user.avatar ' +
        ' FROM  acw.user_email ' +
        ' JOIN acw.user ON user.id = user_email.user ' +
        ' WHERE user_email.email IN ( ? ) AND user.activated = 1 ' +
        ' GROUP BY user.id LIMIT 1 ',
        [emails],
        function (err, rows) {
            if (err) {
                return done(err);
            }
            if (rows.length) {
                var user = rows[0];
                return done(null, user);
            }

            return done(null, false, {message: 'Email não cadastrado.'});
        });
}
passport.use(new GoogleStrategy({
    returnURL: etc.httpProtocol + '://' + etc.DOMAIN + '/auth/google/return',
    realm: etc.httpProtocol + '://' + etc.DOMAIN + '/'
}, extEmailLogin));

passport.use(new YahooStrategy({
    returnURL: etc.httpProtocol + '://' + etc.DOMAIN + '/auth/yahoo/return',
    realm: etc.httpProtocol + '://' + etc.DOMAIN + '/'
}, extEmailLogin));

passport.serializeUser(function (user, done) {
    done(null, user.id);
});

passport.deserializeUser(function (id, done) {
    etc.db.query(' SELECT user.id, user.short_name, user.full_name, user.avatar ' +
        ' FROM  acw.user ' +
        ' WHERE user.id = ' + etc.db.escape(id),
        function (err, rows) {
            if (err) {
                return done(err);
            }
            if (rows.length) {
                var user = rows[0];
                return done(null, user);
            }
            return done(null, false);
        });
});

var app = express();

app.use(express.static(__dirname + '/public'));
app.use(bodyParser());
app.use(cookieParser());

var sessMaxAge = 1000 * 60 * 60 * 24;
app.use(expressSession({
    secret: 'maiorsegredodomundo',
    key: 'acw.sid',
    cookie: { maxAge: sessMaxAge },
    store: new XSession()
}));

app.use(connetFlash());
app.use(passport.initialize());
app.use(passport.session());
app.set('view engine', 'jade');

app.all('*', function (req, res, next) {
    req.etc = etc;
    next();
});

app.get('/', function (req, res) {
    helpers.serveIt('home', '/',  req, res);
});

app.get('/auth/google',
    passport.authenticate('google', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
    }));

app.get('/auth/google/return',
    passport.authenticate('google', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
    }));

app.get('/auth/yahoo',
    passport.authenticate('yahoo', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
    }));


app.get('/auth/yahoo/return',
    passport.authenticate('yahoo', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
    }));

app.get('/login', function (req, res) {
    helpers.serveIt('login', 'login', req, res);
});

app.get('/logout', function (req, res) {
    req.logout();
    res.redirect('/');
});

app.post('/login',
    passport.authenticate('local', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
    }));

require('./controllers/user.js')(app, helpers);

app.listen(4000);