"use strict";
var etc = require('../app.js')();

function setupAuth(){
    var bcrypt = require('bcrypt'),
        LocalStrategy = require('passport-local').Strategy,
        GoogleStrategy = require('passport-google').Strategy,
        YahooStrategy = require('passport-yahoo').Strategy;

    etc.passport = require('passport');
    etc.passport.use(new LocalStrategy({usernameField: 'email'}, function (email, password, done) {
        etc.db.query('SELECT user.id, user.short_name, user.full_name, user.avatar, user.password ' +
                ' FROM  acw.user_email ' +
                ' JOIN acw.active_user ON active_user.user = user_email.user ' +
                ' JOIN acw.user ON user.id = active_user.user ' +
                ' WHERE user_email.email = ? AND user.password IS NOT NULL ',
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

    function extEmailLogin(identifier, profile, done) {
        if (!profile || !profile.emails) {
            return done(null, false, {message: 'Falha no login'});
        }

        var emails = [];
        profile.emails.forEach(function (email) {
            emails.push(email.value);
        });

        etc.db.query(' SELECT user.id, user.short_name, user.full_name, user.avatar ' +
                ' FROM  acw.user_email ' +
                ' JOIN acw.active_user ON active_user.user = user_email.user ' +
                ' JOIN acw.user ON user.id = active_user.user ' +
                ' WHERE user_email.email IN ( ? ) ' +
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
    etc.passport.use(new GoogleStrategy({
        returnURL: etc.httpProtocol + '://' + etc.DOMAIN + '/auth/google/return',
        realm: etc.httpProtocol + '://' + etc.DOMAIN + '/',
        stateless: true
    }, extEmailLogin));
    etc.passport.use(new YahooStrategy({
        returnURL: etc.httpProtocol + '://' + etc.DOMAIN + '/auth/yahoo/return',
        realm: etc.httpProtocol + '://' + etc.DOMAIN + '/',
        stateless: true
    }, extEmailLogin));
    etc.passport.serializeUser(function (user, done) {
        done(null, user.id);
    });
    etc.passport.deserializeUser(function (id, done) {
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

    etc.express.use(etc.passport.initialize());
    etc.express.use(etc.passport.session());
}

exports.init = function (done) {
    etc.authorized = require('authorized');
    require('../lib/authorization.js')(function () {
        setupAuth();
        done();
    });
};

function HandleExternalLogin(req, res, next) {
    var authProvider = this.provider;
    function goDie(req, res) {
        if (authProvider !== 'local') {
            req.flash('error', 'Não foi possível verificar suas credenciais com o ' +
                authProvider.charAt(0).toUpperCase() + authProvider.slice(1) + '.');
        } else {
            req.flash('error', 'Erro no login.');
        }
        return res.redirect('/login');
    }

    etc.passport.authenticate(authProvider, function (err, user, info) {
        if (err) {
            return goDie(req, res);
        }
        if (!user) {
            if (info && info.message) {
                req.flash('error', info.message);
            }
            return res.redirect('/login');
        }
        req.logIn(user, function (err) {
            if (err) {
                return goDie(req, res);
            }
            var to = '/home';
            if (req.session.redirect_to) {
                to = req.session.redirect_to;
                delete req.session.redirect_to;
            }
            res.redirect(to);
        });
    })(req, res, next);
}

exports.listen = function () {
    etc.express.get('/login', function (req, res) {
        if (req.isAuthenticated()) {
            return res.redirect('/home');
        }
        etc.helpers.serveIt('login', 'login', req, res);
    });

    etc.express.get('/logout', function (req, res) {
        req.logout();
        res.redirect('/');
    });

    etc.express.get('/auth/google', HandleExternalLogin.bind({provider: 'google'}));
    etc.express.get('/auth/google/return', HandleExternalLogin.bind({provider: 'google'}));
    etc.express.get('/auth/yahoo', HandleExternalLogin.bind({provider: 'yahoo'}));
    etc.express.get('/auth/yahoo/return', HandleExternalLogin.bind({provider: 'yahoo'}));
    etc.express.post('/login', HandleExternalLogin.bind({provider: 'local'}));
    /*
        etc.express.get('/auth/google',
            etc.passport.authenticate('google', {
                successRedirect: '/',
                failureRedirect: '/login',
                failureFlash: true
            }));

        etc.express.get('/auth/google/return',
            etc.passport.authenticate('google', {
                successRedirect: '/',
                failureRedirect: '/login',
                failureFlash: true
            }));
        etc.express.get('/auth/yahoo',
            etc.passport.authenticate('yahoo', {
                successRedirect: '/',
                failureRedirect: '/login',
                failureFlash: true
            }));
        etc.express.get('/auth/yahoo/return',
            etc.passport.authenticate('yahoo', {
                successRedirect: '/',
                failureRedirect: '/login',
                failureFlash: true
            }));

        etc.express.post('/login',
            etc.passport.authenticate('local', {
                successRedirect: '/',
                failureRedirect: '/login',
                failureFlash: true
            }));
    */
};