var etc = require('../app.js')(), _ = require('lodash');


etc.express.get('/admin', etc.authorized.can('access admin view'), function (req, res) {
    etc.helpers.serveIt('admin', 'admin',  req, res);
});

function listTabs (req, res) {
    var tabs = {
        admin: ['Geral', ['user.create', 'user.on', 'user.off', 'user.admin.on', 'user.admin.off']],
        apps: ['Aplicações', ['app.create', 'app.on', 'app.off']],
        orgs: ['Organizações', ['org.create', 'org.on', 'org.off', 'org.app.on', 'org.app.off', 'org.user.admin.off', 'org.user.admin.on']],
        orgsadm: ['Organização', ['user.create', 'user.on', 'org.user.on', 'org.user.off', 'org.app.user.on', 'org.app.user.off']]
    }, avaibleTabs = [];

    tabs = _.map(tabs, function (tab, id) {
        return {id: id, title: tab[0], actions: tab[1]};
    });

    etc.roles.whatCanUserDo(req.user.id, null, function (err, user) {
        var actions = user.actions;
        if (err) {
            res.send(500);
        }
        for (var i in tabs) {
            if (_.difference(tabs[i].actions, actions).length === 0){
                delete tabs[i].actions;
                avaibleTabs.push(tabs[i]);
            }
        }

        res.json({tabs: avaibleTabs, user: user});
    });
}

etc.express.get('/admin/tabs', etc.authorized.can('access admin view'), listTabs);