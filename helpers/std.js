"use strict";
var pageDeps = require('../config/pageDependencies.js') || {};
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

    var dependencyLoader = "",
        deps = pageDeps[page] || pageDeps.defaults || {};

    if(deps.js && deps.js.length){
        dependencyLoader += "LazyLoad.js(['"+deps.js.join("', '")+"']);\n";
    }

    if(deps.css && deps.css.length){
        dependencyLoader += "LazyLoad.css(['"+deps.css.join("', '")+"']);\n";
    }

    res.locals.dependencyLoader = ((dependencyLoader.length) ? dependencyLoader : null);
    res.render(view);
};
