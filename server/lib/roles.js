var etc = require('../base.js')(), _ = require('lodash');
module.exports = {
    whoCan: function (action, done) {

    },
    canUser: function (user, action, org, done) {
        var args = [user, action];
        if (org) {
            args.push(org);
        }

        etc.db.query('select count(*) c ' +
                ' from role_user ' +
                ' join role_action on role_action.role = role_user.role' +
                ' where ' +
                '   role_user.user = ? ' +
                '   and role_action.action = ?' +
                ((org)?' and org = ?':''),
            args, function(err, rows) {

                if (err) {
                    return done(err);
                }

                done(null, rows.length && rows[0].c > 0);
            });
    },
    whatCanUserDo: function (user, org, done) {
        var args = [user];
        if (org) {
            args.push(org);
        }

        etc.db.query('select role_action.action, role_user.org, role_user.role' +
                ' from role_user' +
                ' join role_action on role_action.role = role_user.role' +
                ' where role_user.user = ?' +
                ((org)?' and role_user.org = ? ':'')+
                ' group by role_action.action, role_user.org, role_user.role',
            args, function (err, rows) {
                if (err) {
                    return done(err);
                }
                var orgs = {}, root = {actions: [], roles: []};

                rows.map(function (row) {
                    var repo = root;

                    if (row.org) {
                        orgs[row.org] = orgs[row.org] || {actions: [], roles: []};
                        repo = orgs[row.org];
                    }

                    if (repo.actions.indexOf(row.action) < 0) {
                        repo.actions.push(row.action);
                    }

                    if (repo.roles.indexOf(row.role) < 0) {
                        repo.roles.push(row.role);
                    }
                });

                return done(null,
                    {
                        actions: _.uniq(rows.map(function (row) {return row.action;})),
                        roles: _.uniq(rows.map(function (row) {return row.role;})),
                        orgs: orgs,
                        root: root
                    }
                );
            });
    },
    isUserA: function (user, role, org, done) {
        var args = [user, role];
        if (org) {
            args.push(org);
        }

        etc.db.query('select count(*) c ' +
                'from role_user ' +
                'where user = ? and role = ?'+
                ((org)?' and org = ?':''),
            args, function(err, rows) {

                if (err) {
                    return done(err);
                }

                done(null, rows.length && rows[0].c > 0);
            });
    }
};