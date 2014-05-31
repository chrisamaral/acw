(function ($) {
    "use strict";
    var userNameForm = $('#userNameForm'),
        userEmailForm = $('#userEmailForm'),
        userTelForm = $('#userTelForm'),
        userPasswordForm = $('#userPasswordForm'),
        DDDs = {};

    function formatAsTel(phone) {
        if (phone.length > 8) {
            return phone.substr(0, 3) + '-' + phone.substr(3, 3) + '-' + phone.substr(6);
        }
        if (phone.length === 8) {
            return phone.substr(0, 4) + '-' + phone.substr(4);
        }
        return phone;
    }
    function submitUserName(event) {
        event.preventDefault();

        var form = $(this), user = {
            short_name: $('input[name="short_name"]').val(),
            full_name: $('input[name="full_name"]').val()
        };

        form.find('.has-error, .alert').removeClass('has-error');

        if (validator.isLength(user.short_name, 3) && validator.isLength(user.full_name, 5)) {
            var bt = form.find('button[type="submit"]').button('loading');
            $.post(form.attr('action'), form.serialize())
                .always(function (data) {
                    bt.button('reset');
                }).done(function () {
                    $('<div class="alert alert-success alert-dismissable">' +
                            '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
                            '<strong>Sucesso,</strong> seu novo nome foi salvo.' +
                        '</div>').prependTo(form).alert();
                }).fail(function (xhr) {
                    $('<div class="alert alert-success alert-warning">' +
                            '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
                            '<strong>Erro</strong> - ' +
                        '</div>').append(xhr.responseText).prependTo(form).alert();
                });
        } else {
            if (!validator.isLength(user.short_name, 3)) {
                form.find('input[name="short_name"]').parent().addClass('has-error');
            } else {
                form.find('input[name="full_name"]').parent().addClass('has-error');
            }
        }
    }
    function submitUserEmail(event) {
        event.preventDefault();

        var form = $(this),
            user = form.serialize(),
            input = form.find('input[name="email"]');

        input.prop('disabled', true).val('');

        $.post(form.attr('action'), user)
            .always(function () {
                input.prop('disabled', false);
                loadEmail();
            })
            .done(function () {
                input.val('');
            });
    }
    function submitUserTel(event) {
        event.preventDefault();

        var form = $(this),
            input = form.find('input,button').not('[type="hidden"]').each(function () {
                var me = $(this);
                if (me.is('input')) {
                    me.val(me.val().replace(/\D/g, ''));
                }
            }),
            user = form.serialize();

        input.prop('disabled', true);

        $.post(form.attr('action'), user)
            .always(function () {
                input.prop('disabled', false);
                loadTel();
            })
            .done(function () {
                input.filter('[name="number"]').val('');
            });
    }
    function submitUserPassword(event) {
        event.preventDefault();

        var form = $(this),
            input = form.find('input,button'),
            user = form.serialize();

        form.find('.has-error').removeClass('has-error');
        form.find('.alert,.errorLabel,.strengthMeter').remove();

        if ($('#newPassword').val() !== $('#repeatPassword').val()) {
            $('#repeatPassword').parent().addClass('has-error');
            $('#repeatPassword').after('<label for=repeatPassword class="control-label errorLabel">' +
                'Não confere</label>');
            return;
        }

        if (strengthMeter.apply($('#newPassword')).score < 3) {
            return;
        }

        input.prop('disabled', true);
        $.post(form.attr('action'), user)
            .always(function () {
                input.prop('disabled', false);
                form.find('.alert,.errorLabel,.strengthMeter').remove();
            })
            .done(function () {
                input.filter('input').val('');
                $('<div class="alert alert-success alert-dismissable">' +
                        '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
                        '<strong>Sucesso,</strong> sua senha foi alterada.' +
                    '</div>').prependTo(form).alert();
            }).fail(function (xhr) {
                $('<div class="alert alert-success alert-warning">' +
                        '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
                        '<strong>Senha não alterada</strong> - ' +
                    '</div>').append(xhr.responseText).prependTo(form).alert();
            });
    }
    function strengthMeter() {
        var me = $(this),
            hmm = zxcvbn(me.val(), [
                'senha', 'difícil', 'fácil', $('input[name="short_name"]').val()
            ].concat($('input[name="full_name"]').val().split(' ')));

        me.next('.strengthMeter').remove();
        var s = $('<label class="control-label strengthMeter">').insertAfter(me);

        if (hmm.score <= 1) {
            s.addClass('text-danger').text('Trivial');
        } else if (hmm.score === 2) {
            s.addClass('text-warning').text('Fraca');
        } else if (hmm.score < 4) {
            s.addClass('text-info').text('Suficiente');
        } else {
            s.addClass('text-success').text('Forte');
        }
        return hmm;
    }

    function killEmail() {
        if ($(this).data('locked')) {
            return;
        }
        var ul = $(this).closest('ul');
        if (ul.children().length < 2) {
            if (!ul.prev().is('.alert')) {
                $('<div class="alert alert-warning alert-dismissable">' +
                        '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
                        '<strong>Ops...</strong> Não é possível remover todos os emails de um usuário.' +
                    '</div>').insertBefore(ul).alert();
            }
            return;
        }

        var me = $(this).data('locked', true).text('...'),
            e = me.parent(),
            email = e.children('span').text();

        $.ajax('/user/email', {
            type: 'DELETE',
            data: { email: email }
        }).always(function () {
            me.data('locked', false).html('&times;');
        }).done(function () {
            e.remove();
        });
    }
    function killTel() {

        if ($(this).data('locked')) {
            return;
        }

        var me = $(this).data('locked', true).text('...'),
            e = me.parent();

        $.ajax('/user/tel', {
            type: 'DELETE',
            data: { tel: me.data('id') }
        }).always(function () {
            me.data('locked', false).html('&times;');
        }).done(function () {
            e.remove();
        });
    }
    function loadEmail() {
        $.getJSON('/user/email', function (data) {
            var emails = data, ul = $('#emailList').empty(), li;

            emails.forEach(function (email) {
                li = $("<li>").addClass('list-group-item').appendTo(ul);
                li.append('<span>' + email + '</span>');
                $('<a aria-hidden=true>').addClass('close')
                    .html('&times;').attr('title', 'Remover').click(killEmail).appendTo(li);
            });

        });
    }
    function loadTel() {
        $.getJSON('/user/tel', function (data) {
            var tels = data, ul = $('#telList').empty(), li;

            tels.forEach(function (tel) {
                li = $("<li>").addClass('list-group-item').appendTo(ul);
                li.append("<span class='badge'>" + tel.area + '</span>' + formatAsTel(tel.number));
                $('<a aria-hidden=true>').addClass('close')
                    .html('&times;').attr('title', 'Remover')
                    .data('id', tel.id).click(killTel).appendTo(li);
            });

        });
    }

    function init() {
        loadEmail();
        loadTel();
        $.getJSON('/json/ddd.json', function (dddList) {
            if (!dddList instanceof Array) {
                return;
            }
            dddList.forEach(function (elem) {

                if (elem instanceof Array) {
                    var ddd = elem.shift();
                    DDDs[ddd] = elem.join(', ');
                }

            });
        }).always(function () {
            userTelForm.submit(submitUserTel);
            var telArea = userTelForm.find('[name="area"]');
            telArea.on('input', updateTelAreaLabel);
            function updateTelAreaLabel() {
                var ddd = $(this).val(), descr = DDDs[ddd] || '';
                $(this).parent().find('.text-info').html(descr);
            }
            updateTelAreaLabel.apply(telArea);
        });

        userNameForm.submit(submitUserName);
        userEmailForm.submit(submitUserEmail);
        userPasswordForm.submit(submitUserPassword);
        $('#newPassword').on('input', strengthMeter);
    }

    window.onLoadRun = init;

}(jQuery));