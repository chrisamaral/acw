(function(a){function e(){a("#oldpic").removeAttr("src");a.getJSON("/user/avatar",function(b){a("#oldpic").attr("src",b.full);a(".userAvatar>img").attr("src",b.thumb)})}function l(a){var c;if(0===a)return"n/a";c=parseInt(Math.floor(Math.log(a)/Math.log(1024)),10);return(a/Math.pow(1024,c)).toFixed(1)+" "+["Bytes","KB","MB"][c]}function g(b){b.preventDefault();if(!parseInt(a("#cropWidth").val(),10))return a('<div class="alert alert-danger alert-dismissable">').append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>').append("<strong>Por favor, selecione o recorte desejado da imagem e tente novamente.</strong>").appendTo("#previewBox"),
!1;b=new FormData(this);var c=a('<progress min="0" max="100" value="0">0% complete</progress>').prependTo("#fileInputBox")[0],d=new XMLHttpRequest;d.open("POST",a(this).attr("action"),!0);d.onload=function(b){a("#fileInputBox,#previewBox").find(".alert,progress").remove();200===this.status?(a("#imageFileSelector").val(""),a("#previewBox").empty().append("<img id=preview>")):a('<div class="alert alert-danger alert-dismissable">').append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>').append("<strong>"+
this.responseText||"N\u00e3o foi poss\u00edvel salvar a imagem, tente novamente.</strong>").appendTo("#previewBox");e()};d.upload.onprogress=function(a){a.lengthComputable&&(c.value=a.loaded/a.total*100,c.textContent=c.value)};d.send(b)}function h(b){a("#cropX").val(b.x);a("#cropY").val(b.y);a("#cropWidth").val(b.w);a("#cropHeight").val(b.h);var f=a("#previewBox").find(".well"),d=a("#resizedInfo");d.length||(d=a('<p id="resizedInfo">').appendTo(f));d.html("<i>Recorte: "+Math.round(b.w/c)+" x "+Math.round(b.h/
c)+"</i>")}function m(){c=1;a("#shrink").val(c);a("#fileInputBox").find(".alert,.well,progress").remove();a("#previewBox").empty().append("<img id=preview>");a("#cropWidth,#cropHeight").val("");var b=a("#preview").removeAttr("src")[0],f=new FileReader,d=a("#imageFileSelector")[0].files[0],e=/^(image\/jpeg|image\/png)$/i,g=l(d.size),k=32*c;d&&(e.test(d.type)?2097152<d.size?a('<div class="alert alert-danger">').append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>').append("<strong>Imagem muito grande. Por favor, selecione uma menor.</strong>").appendTo("#previewBox"):
(f.onload=function(e){var f=a("#previewBox").width();b.src=e.target.result;b.onload=function(){if(32>b.naturalWidth||32>b.naturalHeight)a("#imageFileSelector").val(""),a("#previewBox").empty().append("<img id=preview>"),a('<div class="alert alert-danger">').append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>').append("<strong>Imagem muito pequena. Por favor, selecione uma imagem de pelo menos 32px.</strong>").appendTo("#previewBox");else{var e=b.naturalWidth;
e>f&&(c=f/e);a("#shrink").val(c);a("#preview").width(e*c).height(c*b.naturalHeight);a('<p class="well well-sm" style="margin: 1em 0;">').html(["Tamanho: "+g,"Tipo: "+d.type,"Dimens\u00f5es: "+b.naturalWidth+" x "+b.naturalHeight].join("; ")).insertAfter("#preview");setTimeout(function(){a("#preview").Jcrop({minSize:[k,k],aspectRatio:1,bgFade:!0,bgOpacity:0.3,setSelect:[0,0,Math.min(b.naturalWidth*c,b.naturalHeight*c),Math.min(b.naturalWidth*c,b.naturalHeight*c)],onChange:h,onSelect:h})},1E3)}}},f.readAsDataURL(d)):
a('<div class="alert alert-danger">').append('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>').append("<strong>Arquivo inv\u00e1lido, os formatos aceitos s\u00e3o JPEG e PNG.</strong>").appendTo("#previewBox"))}var c;LazyLoad.css(["/js/ext/Jcrop/css/jquery.Jcrop.min.css"]);LazyLoad.js(["/js/ext/Jcrop/js/jquery.Jcrop.min.js"],function(){a("#imageFileSelector").on("change",m);a("#userAvatarForm").on("submit",g);e()})})(jQuery);
