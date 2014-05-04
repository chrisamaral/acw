"use strict";
var etc = require('../base.js')(), ops = require('../ops/admin.js'), PERMS = 'access admin view';

etc.express.get('/admin', etc.authorized.can('access admin view'), function (req, res) {
    etc.helpers.serveIt('admin', 'admin',  req, res);
});
etc.express.get('/admin/tabs', etc.authorized.can(PERMS), ops.getTabs);
etc.express.get('/admin/users', etc.authorized.can(PERMS), ops.getUsers);