"use strict";
var pageDeps = require('../config/pageDependencies.js') || {},
    _ = require('lodash');
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
    res.locals.url = req.url;
    res.locals.user = req.user;

    res.locals.messages = {
        error: req.flash('error'),
        info: req.flash('info')
    };

    var deps = pageDeps[page] || pageDeps.defaults || {js: [], css: []},
        n_deps = {
            js: ((deps.js && deps.js.length)
                ? "['" + deps.js.concat().join("', '") + "']"
                : null),
            css: ((deps.css && deps.css.length)
                ? deps.css.concat()
                : null)
        };

    res.locals.dependencies = n_deps;
    res.render(view);
};
