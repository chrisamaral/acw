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

    OrgApp = React.createClass({
        toggleApp: function(e){
            this.props.setAppState(this.props.id, e.currentTarget.checked);
            $.ajax(this.props.action, {
                type: e.currentTarget.checked ? 'POST' : 'DELETE'
            });
        },
        render: function () {
            return (<tr>
                <td>
                    <form role='form'>
                        <div className='checkbox'>
                            <input type='checkbox' checked={this.props.enabled} onChange={this.toggleApp} />
                        </div>
                    </form>
                </td>
                <td>{this.props.abbr}</td>
                <td>{this.props.name}</td>
            </tr>);
        }
    });

    OrgApps = React.createClass({
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
                return <OrgApp
                            setAppState={this.setAppState}
                            action={'/admin/org/' + this.props.org + '/app/' + app.id}
                            key={app.id}
                            id={app.id}
                            abbr={app.abbr}
                            name={app.name}
                            enabled={app.enabled} />;
            }.bind(this));
            return <div>
                <h4>Aplicativos</h4>
                <table className='table table-condensed'>
                    <thead>
                        <tr>
                            <th>Ativado</th>
                            <th>Nome</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        {apps}
                    </tbody>
                </table>
            </div>;
        }
    });

    components.OrgManager =  React.createClass({
        getInitialState: function () {
            return {
                selected: new Org(),
                forceUpdate: (new Date()).getTime()
            };
        },
        setSelected: function (item, forceReload) {
            var new_state = {
                selected: !forceReload && item.id === this.state.selected.id
                    ? new Org()
                    : item
            };
            if (forceReload) {
                new_state.forceUpdate = (new Date()).getTime();
            }
            this.setState(new_state);
        },

        render: function () {
            return (<div>
                <div className='row'>
                    <div className='col-md-4'>
                        <OrgList
                            uri='/admin/orgs'
                            forceUpdate={this.state.forceUpdate}
                            selected={this.state.selected}
                            setSelected={this.setSelected} />
                    </div>
                    <div className='col-md-8'>
                        <OrgForm
                            id={this.state.selected.id}
                            item={this.state.selected}
                            action='/admin/org'
                            iname={'organização'}
                            setSelected={this.setSelected} />
                        { this.state.selected.id && this.state.selected.active
                            && <OrgApps org={this.state.selected.id} /> }
                    </div>
                </div>

            </div>);
        }
    });

}(window, jQuery));