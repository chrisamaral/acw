/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        OrgList = components.StdList,
        UserAvatar = components.UserAvatar,
        ContactList = components.ContactList,
        OrgApps,
        OrgApp,
        UserForm;

    function DefaultUser(){
        this.id = null;
        this.short_name = '';
        this.full_name = '';
        this.emails = [];
        this.tels = [];
        this.isAdmin = false;
        this.avatar = null;
        this.name = '';
        this.active = true;
    }
    OrgApp = React.createClass({displayName: 'OrgApp',
        getInitialState: function () {
            return {enabled: this.props.enabled};
        },
        componentWillReceiveProps: function(new_props){
            this.setState({enabled: new_props.enabled});
        },
        toggleApp: function (e) {
            this.setState({enabled: e.currentTarget.checked});
            $.ajax('/admin/org_app/' + this.props.org_app + '/user/' + this.props.user , {
                type: e.currentTarget.checked ? 'POST' : 'DELETE'
            });
        },
        render: function () {
            return React.DOM.div( {className:"checkbox"}, 
                React.DOM.label(null, 
                    React.DOM.input( {type:"checkbox",
                        checked:this.state.enabled,
                        onChange:this.toggleApp} ),this.props.name
                )
            )
        }
    });
    OrgApps = React.createClass({displayName: 'OrgApps',
        getInitialState: function(){
            return {apps: []};
        },
        componentWillReceiveProps: function(new_props){
            this.reloadList(new_props);
        },
        componentDidMount: function () {
            this.reloadList(this.props);
        },
        reloadList: function(props){
            $.get('/admin/org/' + props.org + '/user/' + props.user + '/apps')
                .done(function (arrayOfApps) {
                    this.setState({apps: arrayOfApps});
                }.bind(this));
        },

        render: function () {
            return React.DOM.div(null, 
                React.DOM.h5(null, "Aplicativos Disponíveis"),
                _.map(this.state.apps, function(app){
                    return OrgApp(
                                {key:app.id,
                                enabled:app.enabled,
                                name:app.name,
                                org_app:app.org_app,
                                user:this.props.user} );
                }.bind(this))
            );
        }
    });
    UserForm = React.createClass({displayName: 'UserForm',
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function(){
            return this.props.user;
        },
        setNewEmail: function (e) {
            e.preventDefault();

            var input = this.refs.newEmail.getDOMNode(), new_user = this.state, newEmail = input.value;

            new_user.emails = new_user.emails.concat([newEmail]);

            this.props.setSelected(new_user, true);

            $.post('/admin/user/' + this.state.id + '/email', {email: newEmail});

            input.value = '';
        },
        lookForEmail: function (e) {
            e.preventDefault();
            var input = this.refs.newEmail.getDOMNode(), newEmail = input.value;
            input.disabled = true;
            $.get('/admin/org/' + this.props.org + '/user', {email: newEmail})
                .done(function (foundUser) {
                    if (foundUser) {
                        this.props.setSelected(foundUser);
                    }
                }.bind(this))
                .always(function(){
                    input.value = '';
                    input.disabled = false;
                });

        },
        componentWillReceiveProps: function (new_props) {
            this.setState(new_props.user);
        },
        mainSubmit: function (e) {
            e.preventDefault();
            var uri = '/admin/org/' + this.props.org + '/user';
            $.post(uri, $(e.currentTarget).serialize())
                .done(function(id){
                    var state = this.state;
                    state.id = id;
                    this.props.setSelected(state, true);
                }.bind(this));
        },
        toggleUser: function (e) {
            var uri = '/admin/org/' + this.props.org + '/user/' + this.state.id, new_user = this.state;
            new_user.active = e.currentTarget.checked;
            this.props.setSelected(new_user, true);

            $.ajax(uri, {
                type: e.currentTarget.checked ? 'POST' : 'DELETE'
            });
        },
        toggleAdmin: function(e){
            var uri = '/admin/org/' + this.props.org + '/user/' + this.state.id + '/admin', new_user = this.state;
            new_user.isAdmin = e.currentTarget.checked;
            this.props.setSelected(new_user, true);

            $.ajax(uri, {
                type: e.currentTarget.checked ? 'POST' : 'DELETE'
            });
        },
        render: function () {
            return React.DOM.div( {className:"jumbotron"}, 
                React.DOM.form( {onSubmit:this.mainSubmit, role:"form"}, 
                    React.DOM.div( {className:"row"}, 
                        React.DOM.div( {className:"col-md-3 userAvatarThumbContainer"}, 
                            React.DOM.span(null),
                            UserAvatar( {src:this.props.avatar} )
                        ),
                        React.DOM.div( {className:"col-md-9"}, 
                            React.DOM.div( {className:"row"}, 
                                React.DOM.div( {className:"col-md-5"}, 
                                    React.DOM.div( {className:"form-group"}, 
                                        React.DOM.label( {htmlFor:"orgUserShortName"}, "Nome"),
                                        React.DOM.input( {id:"orgUserShortName",
                                            name:"short_name",
                                            className:"form-control",
                                            type:"text", required:true,
                                            readOnly:this.state.id !== null,
                                            valueLink:this.linkState('short_name')} )
                                    )
                                ),
                                React.DOM.div( {className:"col-md-7"}, 
                                    React.DOM.div( {className:"form-group"}, 
                                        React.DOM.label( {htmlFor:"orgUserFullName"}, "Completo"),
                                        React.DOM.input( {id:"orgUserFullName",
                                            name:"full_name",
                                            className:"form-control",
                                            type:"text", required:true,
                                            readOnly:this.state.id !== null,
                                            valueLink:this.linkState('full_name')} )
                                    )
                                )
                            ),
                            this.state.id === null &&
                                React.DOM.div( {className:"text-right"}, 
                                    React.DOM.button( {type:"submit", className:"btn btn-default"}, "Salvar")
                                )
                        )
                    )
                ),
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-6"}, 
                        React.DOM.form( {role:"form", onSubmit:this.state.id ? this.setNewEmail : this.lookForEmail}, 
                            React.DOM.div( {className:"form-group"}, 
                                React.DOM.input( {ref:"newEmail", name:"email",
                                    type:"email", className:"form-control", required:true,
                                    placeholder:this.state.id ? 'Novo email' : 'Buscar por email'} )
                            )
                        ),
                        this.state.id &&
                            ContactList( {list:this.state.emails} ), 
                        this.state.id &&
                            ContactList( {list:this.state.tels} ) 
                    ),
                    React.DOM.div( {className:"col-md-6"}, 
                        React.DOM.div( {className:"checkbox"}, 
                            React.DOM.label(null, 
                                React.DOM.input( {type:"checkbox", checked:this.state.active || this.state.isAdmin, disabled:this.state.id === null || this.state.isAdmin, onChange:this.toggleUser} ), " Funcionário ativo"
                            )
                        ),
                        React.DOM.div( {className:"checkbox"}, 
                            React.DOM.label(null, 
                                React.DOM.input( {type:"checkbox", checked:this.state.isAdmin, disabled:this.state.id === null, onChange:this.toggleAdmin} ), " Administrador"
                            )
                        ),
                        this.state.id && this.state.active &&
                            OrgApps( {org:this.props.org, user:this.state.id} )
                    )
                )
            );
        }
    });
    components.OrgUserManager =  React.createClass({displayName: 'OrgUserManager',
        getInitialState: function () {
            return {
                selectedOrg: {id: null},
                selectedUser: new DefaultUser(),
                forceUpdate: (new Date()).getTime()
            };
        },
        setSelectedUser: function (item, forceReload) {
            var new_state = {
                selectedUser: !forceReload && item.id === this.state.selectedUser.id
                    ? new DefaultUser()
                    : item
            };

            if (forceReload) {
                new_state.forceUpdate = (new Date()).getTime();
            }

            this.setState(new_state);
        },
        setSelectedOrg: function (item, keepOn) {
            var new_state = {
                selectedOrg: !keepOn && item.id === this.state.selectedOrg.id
                    ? {id: null}
                    : item
            };
            if(new_state.selectedOrg.id !== this.state.selectedOrg.id){
                new_state.selectedUser = new DefaultUser();
            }
            this.setState(new_state);
        },
        render: function () {

            return React.DOM.div( {className:"row"}, 
                React.DOM.div( {className:"col-md-3"}, 
                    React.DOM.h5(null, "Suas organizações"),
                    OrgList( {uri:"/admin/orgs/users",
                            selected:this.state.selectedOrg,
                            setSelected:this.setSelectedOrg} )
                ),
                React.DOM.div( {className:"col-md-3"}, 
                    React.DOM.h5(null, "Usuários"),
                    OrgList( {uri:this.state.selectedOrg.id ? '/admin/org/' + this.state.selectedOrg.id + '/users' : null,
                        selected:this.state.selectedUser,
                        forceUpdate:this.state.forceUpdate,
                        setSelected:this.setSelectedUser} )
                ),
                React.DOM.div( {className:"col-md-6"}, 
                    React.DOM.h5(null, "Usuário"),
                     this.state.selectedOrg.id &&
                        UserForm(
                            {org:this.state.selectedOrg.id,
                            user:this.state.selectedUser,
                            setSelected:this.setSelectedUser} ) 
                )
            );
        } 
    });
}(window, jQuery));