var etc = require('../resources.js')();
var jsPath = '/js/build';

if (etc.ENV === 'development') {
    jsPath = '/js/src';
}
var defaults = {
    js: [
    	"//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js",
    	"//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"
	],css: [
		"//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css",
		"//fonts.googleapis.com/css?family=Droid+Sans:400,700",
		"/css/main.css"
	]
};
exports.defaults = defaults;
exports.user = {
    js: defaults.js.concat([jsPath + '/user.js', jsPath + '/user.avatar.js']),
    css: defaults.css.concat(['/css/user.css'])
};
