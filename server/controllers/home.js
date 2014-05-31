var etc = require('../base.js')(), async = require('async');

etc.express.get('/home', etc.authorized.can('access private page'), function (req, res) {
    async.waterfall(
        [
            function (callback) {
                etc.db.query('SELECT count(*) c FROM role_user WHERE role_user.user = ? AND role_user.role = "admin"',
                    [req.user.id],
                    function (err, rows) {
                        if (err) {
                            callback(err);
                        }
                        callback(null, rows && rows[0] && rows[0].c > 0);
                    });
            },
            function (isAdmin, callback) {
                function appMapper(app) {
                    return {
                        id: app.id,
                        descr: app.descr,
                        name: app.abbr,
                        link: '//' + app.abbr.toLowerCase() + '.' + etc.DOMAIN + '/' + app.orgId,
                        icon: app.icon ? '/media/a/' + app.app + '/' + app.icon : null,
                        org: {
                            name: app.orgAbbr,
                            descr: app.orgName
                        }
                    };
                }
                if (isAdmin) {
                    etc.db.query('SELECT app.id app, org_app.id, app.icon, app.abbr, app.name descr, org.name orgName, org.abbr orgAbbr, org.id orgId ' +
                        'FROM org_app ' +
                        'JOIN app ON app.id = org_app.app ' +
                        'JOIN org ON org.id = org_app.org ' +
                        'ORDER BY app.creation', function (err, rows) {
                            if (err) {
                                return callback(err);
                            }
                            callback(null, rows.map(appMapper));
                        });
                } else {
                    etc.db.query('SELECT app.id app, org_app.id, app.icon, app.abbr, app.name descr, app_user.init, org.abbr orgAbbr, org.name orgName, org.id orgId ' +
                        'FROM app_user ' +
                        'JOIN org_app ON app_user.org_app = org_app.id ' +
                        'JOIN app ON app.id = org_app.app ' +
                        'JOIN org ON org.id = org_app.org ' +
                        'WHERE app_user.user = ? ' +
                        'ORDER BY init', [req.user.id], function (err, rows) {
                            if (err) {
                                return callback(err);
                            }
                            callback(null, rows.map(appMapper));
                        });
                }
            }
        ],
        function (err, apps) {
            if (err) {
                console.log(err);
                res.status(500).render('errors/500');
            }
            res.locals.apps = apps;
            etc.helpers.serveIt('home', 'home',  req, res);
        }
    );

});