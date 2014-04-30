/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React;

    components.UserManager =  React.createClass({displayName: 'UserManager',
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({jumbotron: true});

            return (React.DOM.div( {className:classes}, "I swear my name is " + tab.title));
        } 
    });
}(window, jQuery));