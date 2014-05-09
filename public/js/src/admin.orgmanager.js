/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        OrgList = components.StdList,
        OrgForm = components.StdForm;

    function Org() {
        this.id = null;
        this.abbr = '';
        this.name = '';
        this.active = false;
        this.icon = null;
    }

    components.OrgManager =  React.createClass({displayName: 'OrgManager',
        getInitialState: function () {
            return ({selected: new Org()});
        },
        setSelected: function (item, keepOn) {
            this.setState({
                selected: !keepOn && item.id === this.state.selected.id
                    ? new Org()
                    : item
            });
        },
        setIcon: function (icon) {
            this.setState({selected: _.merge(this.state.selected, {icon: icon})});
        },
        render: function () {
            return (
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        OrgList(
                            {uri:"/admin/orgs",
                            selected:this.state.selected,
                            setSelected:this.setSelected} )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        OrgForm(
                            {id:this.state.selected.id,
                            action:"/admin/org",
                            abbr:this.state.selected.abbr,
                            name:this.state.selected.name,
                            active:this.state.selected.active,
                            setSelected:this.setSelected} )
                    )
                )
                );
        }
    });

}(window, jQuery));