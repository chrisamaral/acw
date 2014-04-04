"use strict";
var pageDeps = require('../config/pageDependencies.js');
exports.ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        res.setHeader('Cache-Control', 'no-cache');
        next();
    } else {
        if (!req.xhr) {
            return res.redirect('/login');
        }
        req.status(403);
    }
};

exports.serveIt = function (view, page, req, res) {
    res.locals.url = req.url;
    res.locals.user = req.user;

    res.locals.messages = {
        error: req.flash('error'),
        info: req.flash('info')
    };

    res.locals.deps = pageDeps[page] || {};
    res.render(view);
};
