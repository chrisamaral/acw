var etc = require('../base.js')(),
    _ = require('lodash'),
    async = require('async'),
    mkdirp = require('mkdirp'),
    mv = require('mv'),
    path = require('path'),
    multiparty = require('multiparty');

exports.getApps = function (req, res) {
    etc.db.query('SELECT app.id, app.abbr, app.name, app.icon, active_app.init '+
            'FROM app ' +
            'LEFT JOIN active_app ON active_app.app = app.id ' +
            'ORDER BY app.creation ',
        function(err, rows){
            if(err){
                return res.send(500);
            }
            res.json(rows.map(function(app){
                app.active = (app.init) ? true : false;
                app.icon = app.icon ? '/media/a/' + app.id + '/' + app.icon : null;
                return app;
            }));
        }
    );
};
exports.saveApp = function(req, res){
    var app = {abbr: req.body.abbr, name: req.body.name},
        appId = req.params.id,
        enabled = req.body.active !== undefined;

    appId = appId && appId.length ? appId : null;

    function updateApp (callback) {
        etc.pool.getNewAdapter(function (db) {
            function onSave(err, info) {
                if (err) {
                    if (err.code = 'ER_DUP_ENTRY') {
                        return res.status(400).send('A abreviação "' + app.abbr + '" já foi utilizada, e é necessário que ela seja única.');
                    }
                    return res.send(500);
                }
                callback(null, db);
            }

            if (!appId) {
                appId = etc.helpers.uniqueID();
                app.id = appId;
                app.creation = (new Date()).toYMD();
                db.insert('app', app, onSave);
            } else {
                db.where('id', appId);
                db.update('app', app, onSave);
            }
        });
    }
    function disableApp (db, callback) {
        db.where('app', appId);
        db.delete('active_app', function(err, info){
            if (err) {
                return res.send(500);
            }
            callback(null, db);
        });
    }
    function enableApp (db, callback) {
        var grant = {app: appId, init: (new Date()).toYMD()};
        db.insert('active_app', grant, function () {
            callback(null, db);
        });
    }

    async.waterfall(
        [updateApp, enabled ? enableApp : disableApp],
        function(err, db){
            db.releaseConnection();
            if (err) {
                return res.send(500);
            }
            res.send(appId);
        }
    );
};
exports.saveIcon = function (req, res) {
    var form = new multiparty.Form(), props = {app: req.params.id};

    function makeDir (callback) {
        mkdirp(this.path, function (err) {
            if (err) {
                return callback([500, 'Erro ao criar diretório da imagem']);
            }
            callback(null);
        });
    }
    function moveFile (callback) {
        mv(this.tmp, this.path + '/' + this.fileName, function(err){
            if (err) {
                console.log(err);
                return callback([500, 'Erro ao mover imagem']);
            }
            callback();
        });
    }
    function saveToDb (callback) {
        etc.db.query('UPDATE app SET icon = ? WHERE id = ?', [this.fileName, this.app], function(err, info){
            if (err) {
                return callback([500, 'Erro ao salvar imagem']);
            }
            callback();
        });
    }

    form.parse(req, function (err, formFields, formFiles) {

        if (err || !formFiles || !formFiles.icon || !formFiles.icon[0] ) {
            return callback([400, 'Imagem inválida']);
        }

        props.path = path.normalize(__dirname + "/../..") + "/public/media/a/" + props.app;
        props.tmp = formFiles.icon[0].path;
        props.fileName = etc.helpers.uniqueID() + path.extname(formFiles.icon[0].path);

        async.waterfall([
            makeDir.bind(props),
            moveFile.bind(props),
            saveToDb.bind(props)
        ], function (err) {
            if (err) {
                return res.status(err[0]).send(err[1]);
            }
            res.send('/media/a/' + this.app + '/' + this.fileName);
        }.bind(props));
    });


};