"use strict";
/*jslint nomen: true*/
var etc = require('../app.js')(), _ = require('lodash');
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
function myUserCreation(callback) {
    var db = this.db, user = this.user;
    db.select('user.creation').where('user.id', user).get('user', function (err, rows) {

        if (err) {
            return callback(err);
        }

        if (!rows.length) {
            return callback('Usuário inválido: ' + user);
        }

        return callback(null, rows[0].creation);
    });
}
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

function countUsers(userCreation, callback) {
    var db = this.db, filterText = this.filterText,
        activeUsersOnly = this.activeUsersOnly;

    db.where('creation > ' + db.escape(userCreation.toYMD()));
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
        callback(null, userCreation, count);
    });
}
function getUsers(userCreation, usersCount, callback) {
    var db = this.db, filterText = this.filterText,
        activeUsersOnly = this.activeUsersOnly,
        offset = this.offset;

    offset = Math.max(0, Math.min(usersCount - 30, offset));
    db.where('creation > ' + db.escape(userCreation));

    if (filterText && !activeUsersOnly) {
        db.join('active_user', 'user.id = active_user.user', 'left');
    } else {
        db.join('active_user', 'user.id = active_user.user');
    }

    db.select(['user.id', 'user.full_name', 'user.short_name', 'IF(active_user.user IS NULL, 0, 1) active']);
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
        async = require('async');
    filterText = (_.isString(filterText) && filterText.length) ? filterText : null;

    etc.pool.getNewAdapter(function (db) {
        async.waterfall(
            [
                myUserCreation.bind({db: db, user: req.user.id}),
                countUsers.bind({db: db, filterText: filterText, activeUsersOnly: activeUsersOnly}),
                getUsers.bind({
                    db: db,
                    filterText: filterText,
                    activeUsersOnly: activeUsersOnly,
                    offset: offset
                })
            ],
            function (err, result) {
                db.releaseConnection();
                if (err) {
                    console.log(err);
                    return res.send(500);
                }
                res.json(result);
            }
        );
    });
};
/*jslint nomen: false*/