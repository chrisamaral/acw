/*
     //cdnjs.cloudflare.com/ajax/libs/react/0.10.0/react-with-addons.min.js
     //cdnjs.cloudflare.com/ajax/libs/react/0.10.0/JSXTransformer.js
 */
(function(window, $){
   'use strict';
    var container = $('.contentWrapper'), user = null;

    function makeTabs(tabs) {

        var tabContainer = $('<div id="tabber">').appendTo(container),
            nav = $('<ul class="nav nav-tabs">').appendTo(tabContainer),
            content = $('<div class="tab-content">').appendTo(tabContainer);

        tabs.forEach(function(tab, index){
            var n = $('<li>').appendTo(nav),
                a = $('<a>')
                        .attr('href', "#"+tab.id)
                        .text(tab.title)
                        //.click(tabChange)
                        .attr('data-toggle', 'tab').appendTo(n),
                c = $('<div class="tab-pane">')
                        .attr('id', tab.id)
                        .text(Math.random().toString(36)).appendTo(content);
        });
        nav.find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            e.target;
            e.relatedTarget;
        }).first().tab('show');
    }
    $.get('/admin/tabs')
        .done(function (response) {
            var tabs = response.tabs;
            user = response.user;

            if (tabs.length) {
                makeTabs(tabs);
            }
        });

}(window, jQuery));