"use strict";
var etc = require('../base.js')(), ops = require('../ops/admin.js');

etc.express.get('/admin', etc.authorized.can('access admin view'), function (req, res) {
    etc.helpers.serveIt('admin', 'admin',  req, res);
});
etc.express.get('/admin/tabs', etc.authorized.can('access admin view'), ops.getTabs);

etc.express.get('/admin/users', etc.authorized.can('list users'), ops.getUsers);
etc.express.get('/admin/user/:id', etc.authorized.can('get user info'), ops.getUser);
etc.express.post('/admin/user', etc.authorized.can('create user'), ops.newUser);
etc.express.post('/admin/user/:id', etc.authorized.can('create user', 'enable user', 'disable user'), ops.saveUser);
etc.express.post('/admin/user/:id/email', etc.authorized.can('create user'), ops.newEmail);

etc.express.get('/admin/apps', etc.authorized.can('list apps'), ops.getApps);
etc.express.post('/admin/app', etc.authorized.can('create app'), ops.saveApp);
etc.express.post('/admin/app/:id', etc.authorized.can('enable app', 'disable app'), ops.saveApp);
etc.express.post('/admin/app/:id/icon', etc.authorized.can('create app'), ops.saveIcon);

etc.express.get('/admin/orgs', etc.authorized.can('list organizations'), ops.getOrgs);
etc.express.post('/admin/org', etc.authorized.can('create organization'), ops.saveOrg);
etc.express.post('/admin/org/:id', etc.authorized.can('enable organization', 'disable organization'), ops.saveOrg);