/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        OrgList = components.StdList,
        OrgForm = components.StdForm,
        OrgApps,
        OrgApp;

    function Org() {
        this.id = null;
        this.abbr = '';
        this.name = '';
        this.active = false;
    }

    OrgApp = React.createClass({displayName: 'OrgApp',
        toggleApp: function(e){
            this.props.setAppState(this.props.id, e.currentTarget.checked);
            $.ajax(this.props.action, {
                type: e.currentTarget.checked ? 'POST' : 'DELETE'
            });
        },
        render: function () {
            return (React.DOM.tr(null, 
                React.DOM.td(null, 
                    React.DOM.form( {role:"form"}, 
                        React.DOM.div( {className:"checkbox"}, 
                            React.DOM.input( {type:"checkbox", checked:this.props.enabled, onChange:this.toggleApp} )
                        )
                    )
                ),
                React.DOM.td(null, this.props.abbr),
                React.DOM.td(null, this.props.name)
            ));
        }
    });

    OrgApps = React.createClass({displayName: 'OrgApps',
        getInitialState: function () {
            return {apps: {}};
        },
        loadApps: function (org) {
            $.get('/admin/org/' + (org || this.props.org) + '/apps')
                .done(function(arrayOfApps){
                    if (arrayOfApps instanceof Array === false) {
                        return;
                    }
                    var apps = {};
                    arrayOfApps.forEach(function (app) {
                        apps[app.id] = app;
                    });
                    this.setState({apps: apps});
                }.bind(this));
        },
        componentDidMount: function(){
            this.loadApps();
        },
        componentWillReceiveProps: function (new_props) {
            this.loadApps(new_props.org);
        },
        setAppState: function (app, enable) {
            var new_apps = this.state.apps;
            new_apps[app].enabled = enable;
            this.setState({apps: new_apps});
        },
        render: function () {
            var apps = _.map(this.state.apps, function(app){
                return OrgApp(
                            {setAppState:this.setAppState,
                            action:'/admin/org/' + this.props.org + '/app/' + app.id,
                            key:app.id,
                            id:app.id,
                            abbr:app.abbr,
                            name:app.name,
                            enabled:app.enabled} );
            }.bind(this));
            return React.DOM.div(null, 
                React.DOM.h4(null, "Aplicativos"),
                React.DOM.table( {className:"table table-condensed"}, 
                    React.DOM.thead(null, 
                        React.DOM.tr(null, 
                            React.DOM.th(null, "Ativado"),
                            React.DOM.th(null, "Nome"),
                            React.DOM.th(null, "Descrição")
                        )
                    ),
                    React.DOM.tbody(null, 
                        apps
                    )
                )
            );
        }
    });

    components.OrgManager =  React.createClass({displayName: 'OrgManager',
        getInitialState: function () {
            return {selected: new Org()};
        },
        setSelected: function (item, keepOn) {
            this.setState({
                selected: !keepOn && item.id === this.state.selected.id
                    ? new Org()
                    : item
            });
        },

        render: function () {
            return (React.DOM.div(null, 
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
                            iname:'organização',
                            abbr:this.state.selected.abbr,
                            name:this.state.selected.name,
                            active:this.state.selected.active,
                            setSelected:this.setSelected} ),
                         this.state.selected.id && this.state.selected.active
                            && OrgApps( {org:this.state.selected.id} ) 
                    )
                )

            ));
        }
    });

}(window, jQuery));