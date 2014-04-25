"use strict";
var pageDeps = require('../config/pages.js') || {},
    etc = require('../app.js')();
exports.ensureAuthenticated = function (req, res, next) {

    if (req.isAuthenticated()) {
        res.setHeader('Cache-Control', 'no-cache');
        return next();
    }

    if (!req.xhr) {
        return res.redirect('/login');
    }

    req.status(403);
};

exports.serveIt = function (view, page, req, res) {
    page = (page === '/') ? null : page;

    function setLocals(title) {
        res.locals.title = title;
        res.locals.url = req.url;
        res.locals.user = req.user;

        res.locals.messages = {
            error: req.flash('error'),
            info: req.flash('info')
        };

        var deps = pageDeps.defaults || {js: [], css: []};

        if (page && page !== '/') {
            deps = pageDeps[page] || deps;
        }

        var n_deps = {
            js: ((deps.js && deps.js.length)
                ? "['" + deps.js.concat().join("', '") + "']"
                : null),
            css: ((deps.css && deps.css.length)
                ? deps.css.concat()
                : null)
        };

        res.locals.dependencies = n_deps;
        res.render(view);
    }

    if (!page) {
        return setLocals(null);
    }

    etc.db.query("SELECT title FROM acw.page WHERE id = ?", [page], function (err, rows) {
        var title = null;
        if (!err && rows[0] && rows[0].title) {
            title = rows[0].title;
        }
        setLocals(title);
    });
};
