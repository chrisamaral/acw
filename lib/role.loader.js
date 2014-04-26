var etc = require('../app.js')();

function defineRole(role){
    etc.authorized.role(role, function(req, done){
        etc.db.query('');
    });
}
module.exports = function(done){
    etc.authorized.role('active_user', function(req, done) {
        var ok = req.isAuthenticated();
        if (ok) {
            req.privatePage = true;
        }
        done(null, ok);
    });
    etc.authorized.role('admin', function(req, done){
        var ok = false;
        if (ok) {
            req.privatePage = true;
        }
        done(null, ok);
    });
    etc.authorized.action('access private page', ['active_user']);
    etc.authorized.action('access admin console', ['admin']);


    done();
};