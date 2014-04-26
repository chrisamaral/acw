var etc = require('../app.js')();

etc.express.get('/admin', etc.authorized.can('access admin console'), function () {
	res.send(200);
});