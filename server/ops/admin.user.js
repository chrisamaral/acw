var etc = require('../base.js')(),
    _ = require('lodash'),
    async = require('async');

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
                result.users = result.users.map(function(user){
                    user.active = user.active > 0;
                    return user;
                });
                res.json(result);
            }
        );
    });
};

exports.getUser = function (req, res) {
    var id = req.params.user;
    etc.db.query('SELECT ' +
            '   user.full_name, user.short_name, user.avatar,' +
            '   GROUP_CONCAT(DISTINCT user_email.email ORDER BY user_email.timestamp SEPARATOR ",") emails,' +
            '   GROUP_CONCAT(DISTINCT concat("(", user_tel.area, ") ", user_tel.number) ORDER BY user_tel.timestamp SEPARATOR ",") tels,' +
            '   active_user.init, active_user.expiration, ' +
            '   role_user.id is_admin ' +
            ' FROM user' +
            " LEFT JOIN role_user ON ( role_user.user = user.id AND role_user.role = 'admin' AND role_user.org IS NULL ) " +
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
            user.isAdmin = user.is_admin !== null;
            delete user.is_admin;
            res.json(user);
        });
};



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
        this.db.insert_ignore('active_user', {
            user: id,
            init: (new Date()).toYMD(),
            expiration: this.expiration
        }, function (err, info) {
            if (err) {
                return callback(err);
            }
            return callback(null, id);
        }, ' ON DUPLICATE KEY UPDATE expiration = ' + this.db.escape(this.expiration));
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
    },
    setAdmin: function(id, callback) {
        var adm = {user: id, org: null, role: 'admin'};
        if (this.isAdmin) {
            adm.init = (new Date()).toYMD();
            this.db.insert_ignore('role_user', adm, function(err, info){
                /* DON'T EVEN CARE
                if (err) {
                    return callback(err);
                }
                */

                return callback(null, id);
            });
        } else {
            this.db.where(adm).delete('role_user', function(err, info){
                if (err) {
                    return callback(err);
                }
                return callback(null, id);
            });
        }
    }
};

function proccessUserUpdate(id, full_name, short_name, expiration, isAdmin, callback) {
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

            isAdmin = isAdmin !== undefined && enabled;
            tasks.push(basicUserOperations.setAdmin.bind({db: db, isAdmin: isAdmin}));

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
    return etc.helpers.dMY_toDate(exp).toYMD();
}
exports.saveUser = function (req, res) {
    proccessUserUpdate(req.params.user,
        req.body.full_name,
        req.body.short_name,
        parseExpiration(req.body.expiration),
        req.body.isAdmin,
        function (err) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        });
};
exports.newUser = function (req, res) {
    proccessUserUpdate(null,
        req.body.full_name,
        req.body.short_name,
        parseExpiration(req.body.expiration),
        req.body.isAdmin,
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
        [req.params.user, req.body.email],
        function (err, info) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        });
};
exports.getOrgUsers = function(req, res) {
    etc.db.query(
        'SELECT * ' +
        'FROM (' +
            'SELECT ' +
                'user.id, ' +
                'user.short_name, ' +
                'user.full_name, ' +
                'user.avatar, ' +
                'user.creation, ' +
                'GROUP_CONCAT(DISTINCT role_user.role SEPARATOR ",") roles, ' +
                'GROUP_CONCAT(DISTINCT concat("(", user_tel.area, ") ", user_tel.number) ORDER BY user_tel.timestamp SEPARATOR ",") tels, ' +
                'GROUP_CONCAT(DISTINCT user_email.email ORDER BY user_email.timestamp SEPARATOR ",") emails ' +
            'FROM user ' +
            'JOIN role_user ON ( role_user.user = user.id AND role_user.org = ? ) ' +
            'LEFT JOIN user_email ON user_email.user = user.id ' +
            'LEFT JOIN user_tel ON user_tel.user = user.id ' +
            'GROUP BY user.id ' +
            'ORDER BY user.full_name ' +
        ') x ' +
        'WHERE roles IS NULL OR roles NOT LIKE "%org.admin%" OR creation > (select creation from user where id = ? ) ',
        [req.params.org, req.user.id],
        function (err, rows) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.json(rows.map(function(user){
                if (user.avatar) {
                    user.avatar = '/media/u/' + user.id + '/1/' + user.avatar;
                }

                user.isAdmin = user.roles.indexOf('org.admin') >= 0;
                user.active = true;
                user.emails = user.emails ? user.emails.split(',') : [];
                user.tels = user.tels ? user.tels.split(',') : [];
                user.name = user.full_name;
                delete user.roles;
                return user;
            }));
        }
    );
};
exports.findUserByEmail = function (req, res) {
    etc.db.query(
            'SELECT * ' +
            'FROM ( ' +
                'SELECT ' +
                    'user.id, ' +
                    'user.short_name, ' +
                    'user.full_name, ' +
                    'user.avatar, ' +
                    'user.creation, ' +
                    'role_user.init is_org_user,' +
                    'GROUP_CONCAT(DISTINCT role_user.role SEPARATOR ",") roles, ' +
                    'GROUP_CONCAT(DISTINCT concat("(", user_tel.area, ") ", user_tel.number) ORDER BY user_tel.timestamp SEPARATOR ",") tels, ' +
                    'GROUP_CONCAT(DISTINCT user_email.email ORDER BY user_email.timestamp SEPARATOR ",") emails ' +
                'FROM user ' +
                'LEFT JOIN role_user ON ( role_user.user = user.id AND role_user.org = ? ) ' +
                'LEFT JOIN user_email ON user_email.user = user.id ' +
                'LEFT JOIN user_tel ON user_tel.user = user.id ' +
                'WHERE ' +
                    ' (SELECT count(*) FROM user_email WHERE user_email.user = user.id AND user_email.email = ? ) > 0 ' +
                'GROUP BY user.id ' +
                'ORDER BY user.full_name ' +
            ') x ' +
            'WHERE roles IS NULL OR roles NOT LIKE "%org.admin%" OR creation > (select creation from user where id = ? ) ',
        [req.params.org, req.query.email, req.user.id],
        function (err, rows) {
            if (err) {
                console.log(err);
                return res.send(500);
            }

            if (!rows[0]) {
                return res.send(404);
            }

            var user = rows[0];

            if (user.avatar) {
                user.avatar = '/media/u/' + user.id + '/1/' + user.avatar;
            }

            user.isAdmin = user.roles && user.roles.indexOf('org.admin') >= 0;
            user.active = user.is_org_user !== null;
            delete user.is_org_user;
            user.emails = user.emails ? user.emails.split(',') : [];
            user.tels = user.tels ? user.tels.split(',') : [];
            user.name = user.full_name;
            delete user.roles;

            res.json(user);
        }
    );
};

exports.newOrgUser = function (req, res) {

    etc.db.query('INSERT IGNORE INTO active_user ' +
        'SET user = ?, init = ? ' +
        'ON DUPLICATE KEY UPDATE timestamp = current_timestamp ',
        [req.params.user, (new Date()).toYMD()],
        function(err, info){
            if (err) {
                console.log(err);
                return res.send(500);
            }
            etc.db.query('INSERT INTO role_user ' +
                    '(user, org, role, init) ' +
                    'VALUES (?, ?, ?, ?)',
                [req.params.user, req.params.org, 'org.user', (new Date()).toYMD()],
                function(err, info) {
                    if (err) {
                        console.log(err);
                        return res.send(500);
                    }
                    res.send(204);
                }
            );
        }
    );
};

exports.removeOrgUser = function(req, res){
    etc.db.query('DELETE FROM role_user WHERE org = ? AND user = ? AND role = ? ',
        [req.params.org, req.params.user, 'org.user'],
        function(err, info) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        }
    );
};
exports.removeOrgAdmin = function(req, res){
    etc.db.query('DELETE FROM role_user WHERE org = ? AND user = ? AND role = ? ',
        [req.params.org, req.params.user, 'org.admin'],
        function(err, info) {
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(204);
        }
    );
};
exports.newOrgAdmin = function (req, res) {
    etc.db.query('INSERT IGNORE INTO active_user ' +
        'SET user = ?, init = ? ' +
        'ON DUPLICATE KEY UPDATE timestamp = current_timestamp ',
        [req.params.user, (new Date()).toYMD()],
        function(err, info){
            if (err) {
                console.log(err);
                return res.send(500);
            }
            etc.db.query('INSERT INTO role_user ' +
                    '(user, org, role, init) ' +
                    'VALUES (?, ?, ?, ?)',
                [req.params.user, req.params.org, 'org.admin', (new Date()).toYMD()],
                function(err, info) {
                    if (err) {
                        console.log(err);
                        return res.send(500);
                    }
                    res.send(204);
                }
            );
        }
    );

};
exports.insertOrgUser = function(req, res){
    etc.pool.getNewAdapter(function (db) {
        async.waterfall([
            basicUserOperations.insertUser.bind({
                db: db,
                short_name: req.body.short_name,
                full_name: req.body.full_name
            }),
            basicUserOperations.enableUser.bind({
                db: db,
                expiration: null
            }),
            function (id, callback) {
                db.insert_ignore('role_user', {
                    org: req.params.org,
                    user: id,
                    role: 'org.user',
                    init: (new Date()).toYMD()
                }, function (err, info) {
                    if (err) {
                        return callback(err);
                    }
                    return callback(null, id);
                }, ' ON DUPLICATE KEY UPDATE timestamp = current_timestamp ')
            }
        ], function(err, id){
            if (err) {
                console.log(err);
                return res.send(500);
            }
            res.send(id);
        });
    });
}