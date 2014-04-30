/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React;

    components.OrgUserManager =  React.createClass({displayName: 'OrgUserManager',
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({jumbotron: true});

            return (React.DOM.div( {className:classes}, "I swear my name is " + tab.title));
        } 
    });
}(window, jQuery));