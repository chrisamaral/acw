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

exports.getUsers = function (req, res) {
    etc.db.query('SELECT user.creation' +
        ' FROM acw.user' +
        ' WHERE user.id = ?',
        [req.user.id],
        function (err, rows) {
            if (err || !rows.length) {
                return res.status(500).send('Usuário inválido');
            }

            etc.db.query('SELECT ' +
                '   user.id, user.full_name, user.short_name' +
                ' FROM acw.active_user' +
                ' JOIN acw.user ON user.id = active_user.user' +
                ' WHERE user.creation > ? ' +
                ' ORDER BY user.full_name' +
                ' LIMIT ?, 20',
                [rows[0].creation, parseInt(req.query.offset, 10)],
                function (err, rows) {
                    if (err) {
                        return res.status(500).send('Não foi possível consultar a lista de usuários');
                    }
                    res.json(rows);
                });
        });
};
/*jslint nomen: false*/