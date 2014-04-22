var _ = require('lodash');
var etc = require('../resources.js')();
var jsPath = '/js/build';

if (etc.ENV === 'development') {
    jsPath = '/js/src';
}
var defaults = {
    js: [
        "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js",
        "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"
    ],
    css: [
        "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css",
        "//fonts.googleapis.com/css?family=Droid+Sans:400,700",
        "/css/main.css"
    ]
};
var pages = {};
exports.defaults = defaults;

pages.user = {
    js: [jsPath + '/user.js', jsPath + '/user.avatar.js'],
    css: ['/css/user.css']
};

pages.login = {
    css: ['/css/login.css']
};


for (var i in pages) {
    var page = {js: pages[i].js || [], css: pages[i].css || []};
    if (!pages[i].standalone) {
        page.js = defaults.js.concat(page.js);
        page.css = defaults.css.concat(page.css);
    }
    exports[i] = page;
}