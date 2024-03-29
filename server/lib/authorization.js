"use strict";
var etc = require('../base.js')();
etc.roles = require('./roles.js');

function definePageAccess(done) {
    etc.db.query('select page.id, group_concat(DISTINCT role_page.role SEPARATOR ":") roles' +
            ' from page' +
            ' join role_page on role_page.page = page.id' +
            ' group by page.id',
        function (err, rows) {
            if (err) {
                return done(err);
            }

            rows.forEach(function (page) {
                etc.authorized.action('access ' + page.id + ' view', page.roles.split(':'));
            });
            done();
        });
}
function defineActions(done) {
    etc.db.query('select action.descr, group_concat(DISTINCT role_action.role SEPARATOR ":") roles' +
            ' from role_action' +
            ' join action on action.id = role_action.action' +
            ' group by role_action.action ',
        function (err, rows) {
            if (err) {
                return done(err);
            }
            rows.forEach(function (action) {
                action.roles = action.roles.split(':');
                //console.log(action.descr, 'is avaible to', action.roles);
                etc.authorized.action(action.descr, action.roles);
            });
            definePageAccess(done);
        });
}

function orgGetter() {
    etc.authorized.entity('org', function (req, done) {

        var org = req.org || req.params.org || null;

        if (!org) {
            return done(null, true);
        }

        etc.db.query('select org.id, org.name from org where org.id = ? ',
            [org],
            function (err, rows) {
                done(err, rows[0]);
            });
    });
}
function defineRole(role) {
    if (role.id.substr(0, 4) === 'org.') {

        etc.authorized.role(role.id, function (org, req, done) {

            org = (org === true) ? null : org;
            if (!req.isAuthenticated()) {
                return done(null, false);
            }
            var args = [role.id, req.user.id];
            if (org) {
                args.push(org.id);
            }
            etc.db.query('select count(*) c ' +
                ' from role_user ' +
                ' where role = ? ' +
                ' and user = ?' +
                (org ? ' and org = ? ' : ''),
                args,
                function (err, rows) {
                    if (err) {
                        return done(err);
                    }
                    var userIs = rows[0] && rows[0].c > 0;
                    //console.log('you', userIs ? 'are' : 'aint',role);
                    done(null, userIs);
                });

        });

    } else {

        etc.authorized.role(role.id, function (req, done) {

            if (!req.isAuthenticated()) {
                return done(null, false);
            }

            etc.db.query('select count(*) c ' +
                    ' from role_user ' +
                    ' where role = ? and org IS NULL and user = ?',
                [role.id, req.user.id],
                function (err, rows) {
                    if (err) {
                        return done(err);
                    }
                    var userIs = rows[0] && rows[0].c > 0;
                    //console.log('you', userIs ? 'are' : 'aint',role);
                    done(null, userIs);
                });
        });
    }
}

function defineRoles(done) {
    etc.db.query('SELECT id FROM role', function (err, rows) {
        if (err) {
            return done(err);
        }
        rows.forEach(defineRole);
        orgGetter();
        defineActions(done);
    });
}

module.exports = function (done) {
    etc.authorized.role('active_user', function (req, done) {
        done(null, req.isAuthenticated());
    });

    var final = function () {
        etc.authorized.action('access private page', ['active_user']);
        done();
    };
    defineRoles(final);
};