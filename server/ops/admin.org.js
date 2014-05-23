var etc = require('../base.js')(),
    _ = require('lodash'),
    async = require('async');

exports.getOrgs = function (req, res) {
    etc.db.query('SELECT org.id, org.abbr, org.name, active_org.init ' +
        'FROM org ' +
        'LEFT JOIN active_org ON org.id = active_org.org ' +
        'ORDER BY org.name',
        function (err, rows){
            if (err) {
                return res.send(500);
            }
            res.json(rows.map(function (org) {
                org.active = org.init !== null;
                delete org.init;
                return org;
            }));
        });
};
exports.saveOrg = function(req, res){
    var org = {abbr: req.body.abbr, name: req.body.name},
        orgId = req.params.org,
        enabled = req.body.active !== undefined;

    orgId = orgId && orgId.length ? orgId : null;

    function updateOrg (callback) {
        etc.pool.getNewAdapter(function (db) {
            function onSave(err, info) {
                if (err) {
                    if (err.code === 'ER_DUP_ENTRY') {
                        return res.status(403).send('O nome "' + org.abbr + '" já foi utilizado.');
                    }
                    return res.send(500);
                }
                callback(null, db);
            }

            if (!orgId) {
                orgId = etc.helpers.uniqueID();
                org.id = orgId;
                org.creation = (new Date()).toYMD();
                db.insert('org', org, onSave);
            } else {
                db.where('id', orgId);
                db.update('org', org, onSave);
            }
        });
    }
    function disableOrg (db, callback) {
        db.where('org', orgId);
        db.delete('active_org', function(err, info){
            if (err) {
                return res.send(500);
            }
            callback(null, db);
        });
    }
    function enableOrg (db, callback) {
        var grant = {org: orgId, init: (new Date()).toYMD()};
        db.insert('active_org', grant, function () {
            callback(null, db);
        });
    }

    async.waterfall(
        [updateOrg, enabled ? enableOrg : disableOrg],
        function(err, db){
            db.releaseConnection();
            if (err) {
                return res.send(500);
            }
            res.send(orgId);
        }
    );
};

exports.getOrgApps = function (req, res) {
    etc.db.query('SELECT app.id, app.abbr, app.name, org_app.id enabled '+
        'FROM app ' +
        'JOIN active_app ON active_app.app = app.id ' +
        'LEFT JOIN org_app ON ( org_app.org = ? AND org_app.app = app.id ) ' +
        'ORDER BY app.abbr ',
        [req.params.org],
        function (err, rows) {
            if (err) {
                return res.send(500);
            }
            res.json(rows.map(function (app) {
                app.enabled = app.enabled !== null;
                return app;
            }));
        }
    );
};
exports.enableOrgApp = function (req, res) {
    etc.db.query('INSERT INTO org_app (org, app, init) ' +
        'VALUES (?, ?, ?)',
        [req.params.org, req.params.app, (new Date()).toYMD()],
        function (err, info) {
            if (err) {
                console.log(err);
            }
            res.send(204);
        });
};
exports.disableOrgApp = function (req, res) {
    etc.db.query('DELETE FROM org_app WHERE org = ? AND app = ? ',
        [req.params.org, req.params.app],
        function (err, info) {
            if (err) {
                console.log(err);
            }
            res.send(204);
        });
};
exports.getUserOrgs = function (req, res) {
    etc.db.query('SELECT org.id, org.abbr, org.name ' +
        'FROM org ' +
        'JOIN active_org ON org.id = active_org.org ' +
        "JOIN role_user ON ( " +
            " ( role_user.role = 'admin' OR ( role_user.org = org.id AND role_user.role = 'org.admin' ) )" +
            " AND role_user.user = ? ) " +
        'GROUP BY org.id ' +
        'ORDER BY org.name',
        [req.user.id],
        function (err, rows) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.json(rows.map(function (row) {
                row.active = true;
                return row;
            }));
        });
};

exports.getUserOrgInfo = function (req, res) {
    etc.db.query('SELECT ' +
            'org.id, org.name org, ' +
            'GROUP_CONCAT(DISTINCT role.descr SEPARATOR ", ") roles, ' +
            'GROUP_CONCAT(DISTINCT app.abbr SEPARATOR ":|:|:") apps ' +
        'FROM org ' +
        'JOIN active_org ON org.id = active_org.org ' +
            'LEFT JOIN org_app ON org_app.org = org.id ' +
            'LEFT JOIN app ON app.id = org_app.app ' +
            'LEFT JOIN app_user ON (app_user.user = ? AND app_user.org_app = org_app.id ) ' +
        "JOIN role_user ON ( " +
            " role_user.org = org.id " +
            " AND role_user.role IN ('org.admin', 'org.user') " +
            " AND role_user.user = ? " +
        " ) " +
        'JOIN role ON role.id = role_user.role ' +
        'GROUP BY org.id ' +
        'ORDER BY org.name',
        [req.params.user, req.params.user],
        function (err, rows) {

            if (err) {
                console.log(err);
                return res.send(500);
            }

            res.json(rows.map(function(row){
                //row.roles = row.roles ? row.roles.split(', ') : [];
                row.apps = row.apps ? row.apps.split(':|:|:') : [];
                return row;
            }));
        });
};