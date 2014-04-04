var etc = require('../resources.js')();
var jsPath = '/js/build';

if (etc.ENV === 'dev') {
    jsPath = '/js/src';
}

module.exports = {
    user: {
        js: [jsPath + '/main.js', jsPath + '/user.js', jsPath + '/user.avatar.js'],
        css: ['/css/user.css']
    }
};
