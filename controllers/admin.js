"use strict";
var etc = require('../app.js')(), ops = require('../ops/admin.js'), PERMS = 'access admin view';

etc.express.get('/admin', etc.authorized.can('access admin view'), function (req, res) {
    etc.helpers.serveIt('admin', 'admin',  req, res);
});
etc.express.get('/admin/tabs', etc.authorized.can(PERMS), ops.getTabs);
etc.express.get('/admin/users', etc.authorized.can(PERMS), ops.getUsers);
etc.express.get('/admin/random', etc.authorized.can(PERMS), function (req, res) {
    var then = Date.now(), q, qs = [], args = [], ids = [],
        names = ['Miguel', 'Davi', 'Arthur', 'Gabriel', 'Pedro', 'Lucas', 'Matheus', 'Bernardo', 'Rafael', 'Guilherme', 'Sophia', 'Julia', 'Alice', 'Manuela', 'Isabella', 'Laura', 'Maria Eduarda', 'Giovanna', 'Valentina', 'Beatriz'],
        surnames = ["Silva", "Santos", "Souza", "Oliveira", "Pereira", "Lima", "Carvalho", "Ferreira", "Rodrigues", "Almeida", "Costa", "Gomes", "Martins", "Araújo", "Melo", "Barbosa", "Ribeiro", "Alves", "Cardoso", "Schmitz", "Rocha", "Correia", "Dias", "Teixeira", "Fernandes", "Azevedo", "Cavalcante", "Montes", "Morais", "Gonçalves"];

    function queryThen() {
        q = etc.db.query(qs.join('   '), args, function (err, rows) {
            if (err) {
                console.log(err);
                return res.status(500).send(q.sql);
            }
            res.send(200);
        });
    }

    function newOne() {
        var id = etc.helpers.uniqueID(), inserts = [],
            r1 = Math.floor(Math.random() * names.length),
            r2 = Math.floor(Math.random() * surnames.length);

        args.push([id, names[r1], names[r1] + ' ' + surnames[r2], new Date()]);
        args.push([id, names[r1].toLowerCase() + '.' + id + '@gmail.com']);

        inserts.push('INSERT INTO acw.user (id, short_name, full_name, creation) VALUES (?);');
        inserts.push('INSERT INTO acw.user_email (user, email) VALUES (?);');
        if (Math.floor(Math.random() * 100) % 2 === 0) {
            inserts.push('INSERT INTO acw.active_user (user, init) VALUES (?);');
            args.push([id, new Date()]);
        }

        console.log('... got', id);
        console.log('and it is', ids.indexOf(id) === -1 ? 'new' : 'repeated');
        ids.push(id);

        qs = qs.concat(inserts);

        if (Date.now() - then > 20 * 1000) {
            return queryThen();
        }

        setTimeout(newOne, 100);
    }

    newOne();
});