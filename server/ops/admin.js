/*jslint nomen: true*/
"use strict";
var etc = require('../base.js')(),
    _ = require('lodash'),
    async = require('async'),
    mkdirp = require('mkdirp'),
    mv = require('mv'),
    path = require('path'),
    multiparty = require('multiparty');
exports.getTabs = function (req, res) {
    var tabs = {
        UserManager: ['Geral', ['user.create', 'user.on', 'user.off', 'user.admin.on', 'user.admin.off']],
        AppManager: ['Aplicações', ['app.create', 'app.on', 'app.off']],
        OrgManager: ['Organizações', ['org.create', 'org.on', 'org.off', 'org.app.on', 'org.app.off', 'org.user.admin.off', 'org.user.admin.on']],
        OrgUserManager: ['Organização', ['user.create', 'user.on', 'org.user.on', 'org.user.off', 'org.app.user.on', 'org.app.user.off']]
    }, avaibleTabs = [];

    tabs = _.map(tabs, function (tab, id) {
        return {id: id, title: tab[0], actions: tab[1]};
    });

    etc.roles.whatCanUserDo(req.user.id, null, function (err, user) {
        var actions = user.actions, i;
        if (err) {
            res.send(500);
        }
        for (i in tabs) {
            if (tabs.hasOwnProperty(i) && _.difference(tabs[i].actions, actions).length === 0) {
                delete tabs[i].actions;
                avaibleTabs.push(tabs[i]);
            }
        }

        res.json({tabs: avaibleTabs, user: user});
    });
};
function filterThem(db, filterText) {
    if (!filterText) {
        return;
    }

    var escaped = db.escape((filterText.length > 3 ? '%' : '') + filterText + '%'),
        where = '  (' +
            '   user.full_name LIKE ' + escaped +
            '   OR user.short_name LIKE ' + escaped +
            '   OR ( ' +
            '       SELECT COUNT(*) ' +
            '       FROM user_email' +
            '       WHERE' +
            '           user_email.user = user.id' +
            '          AND user_email.email LIKE ' + escaped +
            '       ) > 0' +
            '   )';
    db.where(where);
}

function countUsers(callback) {
    var db = this.db, filterText = this.filterText,
        activeUsersOnly = this.activeUsersOnly;

    if (etc.ENV !== 'development') {
        db.where('user.creation > (select creation from user where id = ' + db.escape(this.me) + ' )');
    }

    if (filterText && !activeUsersOnly) {
        db.join('active_user', 'user.id = active_user.user', 'left');
    } else {
        db.join('active_user', 'user.id = active_user.user');
    }

    filterThem(db, filterText);

    db.count('user', function (err, count) {
        if (err) {
            callback(err);
        }
        callback(null, count);
    });
}
function listUsers(usersCount, callback) {
    var db = this.db, filterText = this.filterText,
        activeUsersOnly = this.activeUsersOnly,
        offset = this.offset;

    offset = Math.max(0, Math.min(usersCount - 30, offset));

    if (etc.ENV !== 'development') {
        db.where('user.creation > (select creation from user where id = ' + db.escape(this.me) + ' )');
    }


    if (filterText && !activeUsersOnly) {
        db.join('active_user', 'user.id = active_user.user', 'left');
    } else {
        db.join('active_user', 'user.id = active_user.user');
    }

    db.select([
        'user.id',
        'user.full_name',
        'user.short_name',
        'IF(active_user.user IS NULL, 0, 1) active'
    ]);

    filterThem(db, filterText);

    db.order_by('user.full_name');
    db.limit(30, offset).get('user', function (err, rows) {
        if (err) {
            callback(err);
        }
        callback(null, {users: rows, offset: offset});
    });
}
exports.getUsers = function (req, res) {
    var filterText = req.query.filterText,
        activeUsersOnly = req.query.activeUsersOnly === 'true' ? true : false,
        offset = parseInt(req.query.offset, 10),
        selectedUser = req.query.user;
    filterText = (_.isString(filterText) && filterText.length) ? filterText : null;

    etc.pool.getNewAdapter(function (db) {
        var tasks = [
            countUsers.bind({
                db: db,
                me: req.user.id,
                filterText: filterText,
                activeUsersOnly: activeUsersOnly
            }),
            listUsers.bind({
                db: db,
                me: req.user.id,
                filterText: filterText,
                activeUsersOnly: activeUsersOnly,
                offset: offset
            })
        ];
        if (selectedUser) {
            tasks.push(function(result, callback){

                if(_.any(result.users, {id: selectedUser})){
                    return callback(null, result);
                }

                db.where('user.id', selectedUser);
                db.select([
                    'user.id',
                    'user.full_name',
                    'user.short_name',
                    'IF(active_user.user IS NULL, 0, 1) active'
                ]);
                db.join('active_user', 'user.id = active_user.user', 'left');
                db.get('user', function (err, rows) {
                        if (err) {
                            callback(err);
                        }
                        callback(null, {users: result.users.concat(rows), offset: result.offset});
                    });
            }.bind({db: db}));
        }
        async.waterfall(
            tasks,
            function (err, result) {
                db.releaseConnection();
                if (err) {
                    return res.send(500);
                }
                res.json(result);
            }
        );
    });
};

exports.getUser = function (req, res) {
    var id = req.params.id;
    etc.db.query('SELECT ' +
        '   user.full_name, user.short_name, user.avatar,' +
        '   group_concat(DISTINCT user_email.email ORDER BY user_email.timestamp SEPARATOR ",") emails,' +
        '   group_concat(DISTINCT concat("(", user_tel.area, ") ", user_tel.number) ORDER BY user_tel.timestamp SEPARATOR ",") tels,' +
        '   active_user.init, active_user.expiration' +
        ' FROM user' +
        ' LEFT JOIN user_email ON user_email.user = user.id' +
        ' LEFT JOIN user_tel ON user_tel.user = user.id' +
        ' LEFT JOIN active_user ON active_user.user = user.id ' +
        ' WHERE user.id = ? ' +
        ' GROUP BY user.id',
        [id],
        function (err, rows) {

            if (err) {
                return res.status(500);
            }
            var user = rows[0];

            if (user.avatar) {
                user.avatar = '/media/u/' + id + '/1/' + user.avatar;
            }

            user.emails = user.emails ? user.emails.split(',') : [];
            user.tels = user.tels ? user.tels.split(',') : [];
            user.init = (user.init) ? etc.strftime('%d/%m/%Y', user.init) : null;
            user.expiration = (user.expiration) ? etc.strftime('%d/%m/%Y', user.expiration) : null;
            res.json(user);
        });
};

function dMY_toDate(str) {
    var ds = str.split('/');
    return new Date(
        parseInt(ds[2], 10),
        parseInt(ds[1], 10) - 1,
        parseInt(ds[0], 10),
        0,
        0,
        0
    );
}

var basicUserOperations = {
    insertUser: function (callback) {
        var id = etc.helpers.uniqueID(), newUser = {
            id: id,
            full_name: this.full_name,
            short_name: this.short_name,
            creation: (new Date()).toYMD()
        };

        this.db.insert('user', newUser, function (err, info) {
            if (err) {
                console.log('erro na inserção', err);
                return callback(err);
            }
            callback(null, id);
        });
    },
    updateUser: function (id, callback) {
        this.db.where('id', id).update('user', {
            full_name: this.full_name,
            short_name: this.short_name
        }, function (err, info) {
            if (err) {
                return callback(err);
            }
            return callback(null, id);
        });
    },

    enableUser: function (id, callback) {
        this.db.insert('active_user', {
            user: id,
            init: (new Date()).toYMD(),
            expiration: this.expiration
        }, function (err, info) {
            if (err) {
                return callback(err);
            }
            return callback(null, id);
        });
    },
    disableUser: function (id, callback) {
        this.db.where('user', id).delete('active_user', function (err, info) {
            if (err) {
                return callback(err);
            }
            return callback(null, id);
        });
    },
    changeExpiration: function (id, callback) {
        this.db.where('user', id).update('active_user', {expiration: this.expiration}, function (err, info) {
            if (err) {
                return callback(err);
            }
            return callback(null, id);
        });
    }
};

function proccessUserUpdate(id, full_name, short_name, expiration, callback) {
    etc.pool.getNewAdapter(function (db) {
        function doUpdate(enabled) {
            var tasks = [];

            //atualiza dados do usuário ou insere, caso seja novo
            if (id) {
                tasks.push(function (done) {done(null, id); });
                tasks.push(basicUserOperations.updateUser.bind({db: db, full_name: full_name, short_name: short_name}));
            } else {
                tasks.push(basicUserOperations.insertUser.bind({db: db, full_name: full_name, short_name: short_name}));
            }

            //ativa, desativa ou atualiza data de expiração
            if (expiration === undefined) {
                tasks.push(basicUserOperations.disableUser.bind({db: db}));
            } else {
                if (!enabled || !expiration) {
                    tasks.push(basicUserOperations.enableUser.bind({db: db, expiration: expiration}));
                } else {
                    tasks.push(basicUserOperations.changeExpiration.bind({db: db, expiration: expiration}));
                }
            }

            async.waterfall(
                tasks,
                function (err, id) {
                    db.releaseConnection();
                    if (err) {
                        return callback(err);
                    }
                    callback(null, id);
                }
            );
        }

        if (id) {
            db.where('user', id).count('active_user', function (err, count) {
                if (err) {
                    return callback(err);
                }
                doUpdate(count > 0);
            });
        } else {
            doUpdate(false);
        }
    });
}
function parseExpiration(exp) {
    if (exp === undefined) {
        return exp;
    }
    if (exp === '' || !exp) {
        return null;
    }
    return dMY_toDate(exp).toYMD();
}
exports.saveUser = function (req, res) {
    proccessUserUpdate(req.params.id, req.body.full_name, req.body.short_name, parseExpiration(req.body.expiration),
        function (err) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        });
};
exports.newUser = function (req, res) {
    proccessUserUpdate(null, req.body.full_name, req.body.short_name, parseExpiration(req.body.expiration),
        function (err, id) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(id);
        });
};
exports.newEmail = function (req, res) {
    if (!req.body.email) {
        return res.send(400);
    }
    etc.db.query('INSERT INTO user_email (user, email) VALUES (?, ?)',
        [req.params.id, req.body.email],
        function (err, info) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        });
};
exports.getApps = function (req, res) {
  etc.db.query('SELECT app.id, app.name, app.icon, active_app.init '+
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
    var app = {id: req.body.id, name: req.body.name},
        oldId = req.params.id,
        enabled = req.body.active !== undefined;

    oldId = oldId && oldId.length ? oldId : null;
    app.id = oldId || app.id;

    function updateApp (callback) {
        etc.pool.getNewAdapter(function (db) {
            function onSave(err, info) {
                if (err) {
                    return res.send(500);
                }
                callback(null, db);
            }

            if (!oldId) {
                app.creation = (new Date()).toYMD();
                db.insert('app', app, onSave);
            } else {
                db.where('id', app.id);

                var noIdApp = _.merge({}, app);
                delete noIdApp.id;

                db.update('app', noIdApp, onSave);
            }
        });
    }
    function disableApp (db, callback) {
        db.where('app', app.id);
        db.delete('active_app', function(err, info){
           if (err) {
               return res.send(500);
           }
           callback(null, db);
        });
    }
    function enableApp (db, callback) {
        var grant = {app: app.id, init: (new Date()).toYMD()};
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
            res.send(204);
        }
    )
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
        ], function(err, appPath, fileName){
            if (err) {
                return res.status(err[0]).send(err[1]);
            }
            res.send('/media/a/' + this.app + '/' + this.fileName);
        }.bind(props));
    });


};
/*jslint nomen: false*/