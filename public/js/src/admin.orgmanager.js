/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React;

    components.OrgManager =  React.createClass({displayName: 'OrgManager',
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({jumbotron: true});

            return (React.DOM.div( {className:classes}, "I swear my name is " + tab.title));
        } 
    });
}(window, jQuery));