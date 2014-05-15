"use strict";
var etc = require('../base.js')(), ops = require('../ops/admin.js');

etc.express.get('/admin', etc.authorized.can('access admin view'), function (req, res) {
    etc.helpers.serveIt('admin', 'admin',  req, res);
});
etc.express.get('/admin/tabs', etc.authorized.can('access admin view'), ops.getTabs);

etc.express.get('/admin/users', etc.authorized.can('list users'), ops.getUsers);
etc.express.get('/admin/user/:user', etc.authorized.can('get user info'), ops.getUser);
etc.express.post('/admin/user', etc.authorized.can('create user'), ops.newUser);
etc.express.post('/admin/user/:user', etc.authorized.can('create user', 'enable user', 'disable user'), ops.saveUser);
etc.express.post('/admin/user/:user/email', etc.authorized.can('create user'), ops.newEmail);
etc.express.get('/admin/user/:user/orgs', etc.authorized.can('list users'), ops.getUserOrgInfo);

etc.express.get('/admin/apps', etc.authorized.can('list apps'), ops.getApps);
etc.express.post('/admin/app', etc.authorized.can('create app'), ops.saveApp);
etc.express.post('/admin/app/:app', etc.authorized.can('enable app', 'disable app'), ops.saveApp);
etc.express.post('/admin/app/:app/icon', etc.authorized.can('create app'), ops.saveIcon);

etc.express.get('/admin/orgs', etc.authorized.can('list organizations'), ops.getOrgs);
etc.express.post('/admin/org', etc.authorized.can('create organization'), ops.saveOrg);
etc.express.post('/admin/org/:org', etc.authorized.can('enable organization', 'disable organization'), ops.saveOrg);
etc.express.get('/admin/org/:org/apps', etc.authorized.can('list organizations'), ops.getOrgApps);

etc.express.post('/admin/org/:org/app/:app', etc.authorized.can('enable organization'), ops.enableOrgApp);
etc.express.delete('/admin/org/:org/app/:app', etc.authorized.can('enable organization'), ops.disableOrgApp);

etc.express.get('/admin/orgs/users', etc.authorized.can('list organization users'), ops.getUserOrgs);

etc.express.get('/admin/org/:org/users', etc.authorized.can('list organization users'), ops.getOrgUsers);
etc.express.get('/admin/org/:org/user',  etc.authorized.can('list organization users'), ops.findUserByEmail);

etc.express.post('/admin/org/:org/user', etc.authorized.can('create user', 'enable user', 'add user to organization'), ops.insertOrgUser);
etc.express.post('/admin/org/:org/user/:user', etc.authorized.can('add user to organization'), ops.newOrgUser);
etc.express.delete('/admin/org/:org/user/:user', etc.authorized.can('remove user from organization'), ops.removeOrgUser);
etc.express.post('/admin/org/:org/user/:user/admin', etc.authorized.can('set user as org.admin'), ops.newOrgAdmin);
etc.express.delete('/admin/org/:org/user/:user/admin', etc.authorized.can('unset user as org.admin'), ops.removeOrgAdmin);

etc.express.get('/admin/org/:org/user/:user/apps', etc.authorized.can('enable access to app instance'), ops.getOrgUserApps);

etc.express.post('/admin/org_app/:org_app/user/:user', etc.authorized.can('enable access to app instance'), ops.newUserApp);
etc.express.delete('/admin/org_app/:org_app/user/:user', etc.authorized.can('disable access to app instance'), ops.removeUserApp);

