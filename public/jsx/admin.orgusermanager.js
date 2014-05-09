/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React;

    components.OrgUserManager =  React.createClass({
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({jumbotron: true});

            return (<div className={classes}>{"I swear my name is " + tab.title}</div>);
        } 
    });
}(window, jQuery));