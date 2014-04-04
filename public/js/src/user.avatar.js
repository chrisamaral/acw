(function ($) {
    "use strict";
    var shrink;
    function loadAvatar() {
        $('#oldpic').removeAttr('src');
        $.getJSON('/user/avatar', function (src) {
            $('#oldpic').attr('src', src.full);
            $('.userAvatar>img').attr('src', src.thumb);
        });
    }
    function bytesToSize(bytes) {
        var sizes = ['Bytes', 'KB', 'MB'], i;
        if (bytes === 0) {
            return 'n/a';
        }
        i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
        return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
    }
    function checkForm(event) {
        event.preventDefault();
        if (!parseInt($('#cropWidth').val(), 10)) {
            $('<div class="alert alert-danger alert-dismissable">')
                .append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>')
                .append('<strong>Por favor, selecione o recorte desejado da imagem e tente novamente.</strong>')
                .appendTo('#previewBox');
            return false;
        }


        var form = new FormData(this),
            progressBar = $('<progress min="0" max="100" value="0">0% complete</progress>')
                .prependTo('#fileInputBox')[0],
            xhr = new XMLHttpRequest();

        xhr.open('POST', $(this).attr('action'), true);
        xhr.onload = function (e) {
            $('#fileInputBox,#previewBox').find('.alert,progress').remove();
            if (this.status === 200) {
                $('#imageFileSelector').val('');
                $('#previewBox').empty().append("<img id=preview>");
            } else {
                $('<div class="alert alert-danger alert-dismissable">')
                    .append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>')
                    .append('<strong>' + this.responseText || 'Não foi possível salvar a imagem, tente novamente.' + '</strong>')
                    .appendTo('#previewBox');
            }
            loadAvatar();
        };
        xhr.upload.onprogress = function (e) {
            if (e.lengthComputable) {
                progressBar.value = (e.loaded / e.total) * 100;
                progressBar.textContent = progressBar.value;
            }
        };
        xhr.send(form);
    }

    function updateInfo(e) {

        $('#cropX').val(e.x);
        $('#cropY').val(e.y);
        $('#cropWidth').val(e.w);
        $('#cropHeight').val(e.h);

        var container = $('#previewBox').find('.well'), info = $('#resizedInfo');
        if (!info.length) {
            info = $('<p id="resizedInfo">').appendTo(container);
        }
        info.html("<i>Recorte: " + Math.round(e.w / shrink) + " x " + Math.round(e.h / shrink) + '</i>');
    }


    function fileSelectHandler() {

        shrink = 1;
        $('#shrink').val(shrink);
        $('#fileInputBox').find('.alert,.well,progress').remove();
        $('#previewBox').empty().append("<img id=preview>");
        $('#cropWidth,#cropHeight').val('');

        var oImage = $('#preview').removeAttr('src')[0],
            oReader = new FileReader(),
            oFile = $('#imageFileSelector')[0].files[0],
            rFilter = /^(image\/jpeg|image\/png)$/i,
            sResultFileSize = bytesToSize(oFile.size),
            minDim = 32 * shrink;

        if (!oFile) {
            return;
        }

        if (!rFilter.test(oFile.type)) {
            $('<div class="alert alert-danger">')
                .append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>')
                .append('<strong>Arquivo inválido, os formatos aceitos são JPEG e PNG.</strong>').appendTo('#previewBox');
            return;
        }

        if (oFile.size > 1024 * 1024 * 2) {
            $('<div class="alert alert-danger">')
                .append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>')
                .append('<strong>Imagem muito grande. Por favor, selecione uma menor.</strong>').appendTo('#previewBox');
            return;
        }

        oReader.onload = function (e) {
            var boxW = $('#previewBox').width();
            oImage.src = e.target.result;
            oImage.onload = function () {
                if (oImage.naturalWidth < 32 || oImage.naturalHeight < 32) {
                    $('#imageFileSelector').val('');
                    $('#previewBox').empty().append("<img id=preview>");
                    $('<div class="alert alert-danger">')
                        .append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>')
                        .append('<strong>Imagem muito pequena. Por favor, selecione uma imagem de pelo menos 32px.</strong>').appendTo('#previewBox');

                    return;
                }
                var imgW = oImage.naturalWidth;
                if (imgW >  boxW) {
                    shrink = boxW / imgW;
                }
                $('#shrink').val(shrink);
                $('#preview').width(imgW * shrink).height(shrink * oImage.naturalHeight);

                $('<p class="well well-sm" style="margin: 1em 0;">').html(
                    [
                        "Tamanho: " + sResultFileSize,
                        "Tipo: " + oFile.type,
                        "Dimensões: " + oImage.naturalWidth + ' x ' + oImage.naturalHeight
                    ].join('; ')
                ).insertAfter('#preview');

                setTimeout(function () {

                    $('#preview').Jcrop({
                        minSize: [minDim, minDim],
                        aspectRatio : 1,
                        bgFade: true,
                        bgOpacity: 0.3,
                        setSelect:
                            [
                                0,
                                0,
                                Math.min(oImage.naturalWidth * shrink, oImage.naturalHeight * shrink),
                                Math.min(oImage.naturalWidth * shrink, oImage.naturalHeight * shrink)
                            ],
                        onChange: updateInfo,
                        onSelect: updateInfo
                    });
                }, 1000);
            };
        };
        oReader.readAsDataURL(oFile);
    }

    function avatarUploadSetUp() {
        $('#imageFileSelector').on('change', fileSelectHandler);
        $('#userAvatarForm').on('submit', checkForm);
        loadAvatar();
    }
    LazyLoad.css(['/js/ext/Jcrop/css/jquery.Jcrop.min.css']);
    LazyLoad.js(['/js/ext/Jcrop/js/jquery.Jcrop.min.js'], avatarUploadSetUp);
}(jQuery));