"use strict";
var pageDeps = require('../config/pages.js') || {},
    etc = require('../app.js')();

function setLocals(req, res, page, view, title) {
    res.locals.title = title;
    res.locals.url = req.url;
    res.locals.user = (req.isAuthenticated()) ? req.user : null;
    res.locals.jsPath = (etc.ENV === 'development') ? 'src' : 'build';
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

function loadPages(req, res, page, view, title){
    if (!req.isAuthenticated()) {
        return setLocals(req, res, page, view, title);
    }
    etc.db.query("SELECT page.id, page.title" +
            " FROM acw.role_user" +
            " JOIN acw.role_page ON role_page.role = role_user.role" +
            " JOIN acw.page ON page.id = role_page.page" +
            " WHERE role_user.user = ?" +
            " GROUP BY page.id",
        [req.user.id],
        function (err, rows) {
            var pages = [];
            if (!err && rows.length) {
                pages = rows.concat();
            }
            res.locals.pages = pages;
            setLocals(req, res, page, view, title);
        });
}

exports.serveIt = function (view, page, req, res) {

    page = (page === '/') ? null : page;

    if (!page) {
        return loadPages(req, res, page, view, null);
    }

    etc.db.query("SELECT title FROM acw.page WHERE id = ?", [page], function (err, rows) {
        var title = null;

        if (!err && rows[0] && rows[0].title) {
            title = rows[0].title;
        }

        if (!req.isAuthenticated()) {
            return setLocals(req, res, page, view, title);
        }

        loadPages(req, res, page, view, title);
    });
};

exports.uniqueID = function () {
    return String.fromCharCode(65 + Math.floor(Math.random() * 26)).toLowerCase() + Date.now().toString(36);
};
exports.escapeEmAll = function (a) {
    return a.map(function (elem) {
        return etc.db.escape(elem);
    });
};