var etc = require('../base.js')(),
    _ = require('lodash'),
    async = require('async');

exports.getOrgs = function (req, res) {
    etc.db.query('SELECT org.id, org.abbr, org.name, org.icon, active_org.init ' +
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
        orgId = req.params.id,
        enabled = req.body.active !== undefined;

    orgId = orgId && orgId.length ? orgId : null;

    function updateOrg (callback) {
        etc.pool.getNewAdapter(function (db) {
            function onSave(err, info) {
                if (err) {
                    if (err.code = 'ER_DUP_ENTRY') {
                        return res.status(400).send('A abreviação "' + org.abbr + '" já foi utilizada, e é necessário que ela seja única.');
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