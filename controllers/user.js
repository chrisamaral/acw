"use strict";


module.exports = function (app, helpers) {

    var etc = require('../resources.js')(),
        validator = require('validator'),
        bcrypt = require('bcrypt'),
        zxcvbn = require('zxcvbn'),
        fs = require('fs'),
        mkdirp = require('mkdirp'),
        gm = require('gm'),
        path = require('path'),
        formidable = require('formidable');

    app.get('/user/avatar', helpers.ensureAuthenticated, function (req, res) {
        if (req.user.avatar) {
            res.send({
                full: '/media/u/' + req.user.id + '/1/' + req.user.avatar,
                thumb: '/media/u/' + req.user.id + '/thumb/' + req.user.avatar,
            });
        } else {
            res.send({
                full: '/img/user-large.png',
                thumb: '/img/user.png'
            });
        }
    });
    app.post('/user/avatar', helpers.ensureAuthenticated, function (req, res) {
        var tmpFile = null, form = new formidable.IncomingForm();
        function answerIt(status, txt) {
            if (tmpFile) {
                fs.unlink(tmpFile);
            }
            res.status(status || 500);
            res.send(txt || 'Falha no upload.');
        }

        form.parse(req, function (err, formFields, formFiles) {
            if (err || !formFiles || !formFiles.pic) {
                return answerIt(400, 'Nenhuma imagem.');
            }

            tmpFile = formFiles.pic.path;
            var fname = (+new Date()).toString(36) + path.extname(formFiles.pic.name),
                usrPath = path.normalize(__dirname + "/..") + "/public/media/u/" + req.user.id,
                shrink = parseFloat(formFields.shrink),
                dim = {
                    width: parseInt(formFields.cropWidth, 10) / shrink,
                    height: parseInt(formFields.cropHeight, 10) / shrink,
                    x: parseInt(formFields.cropX, 10) / shrink,
                    y: parseInt(formFields.cropY, 10) / shrink
                };

            mkdirp(usrPath + '/1', function (err) {
                gm(formFiles.pic.path)
                    .crop(dim.width, dim.height, dim.x, dim.y)
                    .write(usrPath + '/1/' + fname, function (err) {
                        if (err) {
                            return answerIt(500, 'Não foi possível salvar a nova foto, falha ao recortar imagem.');
                        }
                        mkdirp(usrPath + '/thumb', function (err) {
                            gm(usrPath + '/1/' + fname)
                                .thumb(32, 32, usrPath + '/thumb/' + fname, function (err) {
                                    if (err) {
                                        return answerIt(500, 'Não foi possível salvar a nova foto, falha ao gerar miniatura');
                                    }
                                    etc.db.query(
                                        'UPDATE acw.user SET ? WHERE user.id = ? ',
                                        [{avatar: fname}, req.user.id],
                                        function (err, result) {
                                            if (err) {
                                                return answerIt(500, 'Não foi possível salvar a nova foto, falha ao gravar no banco de dados.');
                                            }
                                            answerIt(200, 'OK');
                                        }
                                    );
                                });
                        });
                    });
            });
        });
    });
    app.get('/user/name', helpers.ensureAuthenticated, function (req, res) {
        res.json({
            short_name: req.user.short_name,
            full_name: req.user.full_name,
        });
    });

    app.post('/user/name', helpers.ensureAuthenticated, function (req, res) {

        if (!validator.isLength(req.body.short_name, 3) || !validator.isLength(req.body.full_name, 3)) {
            res.status(400);
            return res.send('Nome inválido');
        }

        var user = {
            short_name: req.body.short_name,
            full_name: req.body.full_name
        };

        etc.db.query(' UPDATE acw.user SET ? WHERE user.id = ? ', [user, req.user.id],
            function (err, result) {
                if (err) {
                    res.status(500);
                    return res.send('Não foi possível salvar o novo nome.');
                }
                res.send(200);
            });
    });
    app.get('/user/tel', helpers.ensureAuthenticated, function (req, res) {
        etc.db.query(' SELECT user_tel.id, user_tel.country, user_tel.area, user_tel.number ' +
            ' FROM acw.user_tel ' +
            ' WHERE user_tel.user = ? ' +
            ' ORDER BY user_tel.timestamp ', [req.user.id],
            function (err, rows) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível completar sua requisição.');
                    return;
                }

                var tels = [];

                if (!rows || !rows.length) {
                    res.json(tels);
                }

                rows.forEach(function (element) {
                    tels.push(element);
                });

                res.json(tels);
            });
    });
    app.post('/user/tel', helpers.ensureAuthenticated, function (req, res) {
        if (
            !(
                validator.isLength(req.body.country, 1)
                && validator.isLength(req.body.area, 1)
                && validator.isLength(req.body.number, 1)
            )
        ) {
            res.status(400);
            res.send('Número de telefone inválido.');
            return;
        }

        etc.db.query(' INSERT INTO acw.user_tel SET ? ',
            [{
                country: String(req.body.country).replace(/\D/g, ''),
                area: String(req.body.area).replace(/\D/g, ''),
                number: String(req.body.number).replace(/\D/g, ''),
                user: req.user.id
            }],
            function (err, result) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível salvar o novo número.');
                    return;
                }
                res.send(200);
            });
    });
    app.delete('/user/tel', helpers.ensureAuthenticated, function (req, res) {

        etc.db.query(' DELETE FROM acw.user_tel WHERE user_tel.user = ? AND user_tel.id = ? ',
            [req.user.id, req.body.tel],
            function (err, result) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível completar sua requisição.');
                    return;
                }
                res.send(200);
            });
    });

    app.get('/user/email', helpers.ensureAuthenticated, function (req, res) {
        etc.db.query(' SELECT user_email.email ' +
            ' FROM acw.user_email ' +
            ' WHERE user_email.user = ? ' +
            ' ORDER BY user_email.timestamp ', [req.user.id],
            function (err, rows) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível completar sua requisição.');
                    return;
                }

                var emails = [];

                if (!rows || !rows.length) {
                    res.json(emails);
                }

                rows.forEach(function (element) {
                    emails.push(element.email);
                });

                res.json(emails);
            });
    });

    app.post('/user/email', helpers.ensureAuthenticated, function (req, res) {
        if (!validator.isEmail(req.body.email)) {
            res.status(400);
            return res.send('Email inválido.');
        }
        etc.db.query(' INSERT INTO acw.user_email SET ? ', [{email: req.body.email, user: req.user.id}],
            function (err, result) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível salvar o novo email.');
                    return;
                }
                return res.send(200);
            });
    });

    app.delete('/user/email', helpers.ensureAuthenticated, function (req, res) {
        function actuallyDelete() {
            etc.db.query(' DELETE FROM acw.user_email WHERE user_email.user = ? AND user_email.email = ? ',
                [req.user.id, req.body.email],
                function (err, result) {
                    if (err) {
                        res.status(500);
                        res.send('Não foi possível completar sua requisição.');
                        return;
                    }
                    res.send(200);
                });
        }

        etc.db.query(' SELECT COUNT(*) c FROM acw.user_email WHERE user_email.user = ? ',
            [req.user.id],
            function (err, result) {
                if (err) {
                    res.status(500);
                    res.send('Não foi possível completar sua requisição.');
                    return;
                }

                if (!result[0] || parseInt(result[0].c, 10) < 2) {
                    res.status(403);
                    return res.send('É necessário que haja pelo menos um email para cada usuário.');
                }

                actuallyDelete();
            });
    });
    app.post('/user/password', helpers.ensureAuthenticated, function (req, res) {

        if (!validator.isLength(req.body.newPassword, 1) || zxcvbn(req.body.newPassword) < 3) {
            res.status(400);
            res.send('Senha Inválida.');
            return;
        }

        if (req.body.newPassword !== req.body.repeatPassword) {
            res.status(400);
            res.send('Você falhou a repetição das senhas.');
            return;
        }

        function actuallyChangePassword() {
            bcrypt.genSalt(10, function (err, salt) {

                if (err) {
                    return res.send(500);
                }

                bcrypt.hash(req.body.newPassword, salt, function (err, hash) {

                    if (err) {
                        return res.send(500);
                    }

                    etc.db.query(' UPDATE acw.user SET ? WHERE user.id = ?',
                        [{password: hash}, req.user.id],
                        function (err, result) {
                            if (err) {
                                res.status(500);
                                res.send('Não foi possível completar sua requisição.');
                                return;
                            }
                            return res.send(200);
                        });

                });
            });
        }

        etc.db.query(' SELECT user.password FROM acw.user WHERE user.id = ? ',
            [req.user.id],
            function (err, result) {
                if (err) {
                    res.status(500);
                    return res.send('Não foi possível completar sua requisição.');
                }

                if (result && result.length) {
                    var user = result[0];

                    if (user.password === null) {
                        return actuallyChangePassword();
                    }

                    bcrypt.compare(req.body.oldPassword, user.password, function (err, match) {
                        if (err) {
                            return res.send(500);
                        }

                        if (match) {
                            return actuallyChangePassword();
                        }

                        res.status(400);
                        return res.send('Senha antiga não confere.');
                    });

                    return;
                }

                res.send(400);
            });
    });
    app.get('/user', helpers.ensureAuthenticated, function (req, res) {
        helpers.serveIt('user', 'user', req, res);
    });

};