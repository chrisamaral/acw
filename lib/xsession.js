"use strict";
var etc = require('../app.js')();

module.exports = function (expressSession) {
    function MySQLXStore(options) {
        options = options || {};
        expressSession.Store.call(this, options);
        var checkExpirationInterval = options.checkExpirationInterval || 1000 * 60 * 10;
        function killOldSessions() {
            etc.db.query('DELETE FROM acw.session WHERE expires < current_timestamp ', function (err) {
                if (err) {
                    throw err;
                }
            });
        }
        setInterval(killOldSessions, checkExpirationInterval);
        killOldSessions();
    }
    MySQLXStore.prototype.get = function (sid, fn) {
        etc.db.query('SELECT * FROM acw.session WHERE sid = ? ', [sid], function (err, rows) {

            if (err) {
                return fn(err);
            }

            if (!rows || !rows.length) {
                return fn();
            }
            var session;

            try {
                session = JSON.parse(rows[0].data);
            } catch (parse_err) {
                session = null;
                //return fn(parse_err);
            }

            fn(null, session);
        });
    };

    MySQLXStore.prototype.set = function (sid, session, fn) {
        if (!session) {
            return fn();
        }

        if (session.passport && session.passport.user) {
            session.user = session.passport.user;
        }

        var serialized = {sid: sid, data: JSON.stringify(session)};
        if (session.passport && session.passport.user) {
            serialized.user = session.passport.user;
            etc.db.query('DELETE FROM acw.session WHERE session.user = ? AND session.sid != ? ', [serialized.user, sid]);
        }

        if (session.cookie.expires) {
            serialized.expires = session.cookie.expires;
        }

        serialized.creation = new Date();
        etc.db.query('INSERT INTO acw.session SET ?', serialized, function (err, result) {
            if (err) {
                delete serialized.sid;
                delete serialized.creation;
                etc.db.query('UPDATE acw.session SET ? WHERE sid = ?', [serialized, sid], function (err) {
                    if (err) {
                        return fn(err);
                    }

                    fn();
                });
                return;
            }

            fn();
        });
    };

    MySQLXStore.prototype.destroy = function (sid, fn) {
        etc.db.query('DELETE FROM acw.session WHERE sid = ? ', [sid], function (err) {
            if (err) {
                return fn(err);
            }
            fn();
        });
    };

    MySQLXStore.prototype.length = function (callback) {
        etc.db.query('SELECT count(*) c FROM acw.session', function (err, rows) {
            if (err) {
                callback(null);
            }
            callback(rows[0].c);
        });
    };

    MySQLXStore.prototype.clear = function (callback) {
        etc.db.query('DELETE FROM acw.session', callback);
    };

    MySQLXStore.prototype.__proto__ = expressSession.Store.prototype;

    return MySQLXStore;
};