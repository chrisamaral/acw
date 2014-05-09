/*jslint nomen: true*/
"use strict";
var etc = require('../base.js')(),
    _ = require('lodash'),
    ops;
ops = _.merge({}, require('./admin.user.js'), require('./admin.app.js'), require('./admin.org.js'));

ops.getTabs = function (req, res) {
    var tabs = {
        UserManager: ['Geral', ['user.create', 'user.on', 'user.off', 'user.admin.on', 'user.admin.off']],
        AppManager: ['Aplicativos', ['app.create', 'app.on', 'app.off']],
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
module.exports = ops;
/*jslint nomen: false*/