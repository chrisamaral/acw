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
    OrgApp = React.createClass({
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
            return <div className='checkbox'>
                <label>
                    <input type='checkbox'
                        checked={this.state.enabled}
                        onChange={this.toggleApp} />{this.props.name}
                </label>
            </div>
        }
    });
    OrgApps = React.createClass({
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
            return <div>
                <h5>Aplicativos Disponíveis</h5>
                {_.map(this.state.apps, function(app){
                    return <OrgApp
                                key={app.id}
                                enabled={app.enabled}
                                name={app.name}
                                org_app={app.org_app}
                                user={this.props.user} />;
                }.bind(this))}
            </div>;
        }
    });
    UserForm = React.createClass({
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
            return <div className='jumbotron'>
                <form onSubmit={this.mainSubmit} role='form'>
                    <div className='row'>
                        <div className='col-md-3 userAvatarThumbContainer'>
                            <span></span>
                            <UserAvatar src={this.props.avatar} />
                        </div>
                        <div className='col-md-9'>
                            <div className='row'>
                                <div className='col-md-5'>
                                    <div className='form-group'>
                                        <label htmlFor='orgUserShortName'>Nome</label>
                                        <input id='orgUserShortName'
                                            name='short_name'
                                            className='form-control'
                                            type='text' required={true}
                                            readOnly={this.state.id !== null}
                                            valueLink={this.linkState('short_name')} />
                                    </div>
                                </div>
                                <div className='col-md-7'>
                                    <div className='form-group'>
                                        <label htmlFor='orgUserFullName'>Completo</label>
                                        <input id='orgUserFullName'
                                            name='full_name'
                                            className='form-control'
                                            type='text' required={true}
                                            readOnly={this.state.id !== null}
                                            valueLink={this.linkState('full_name')} />
                                    </div>
                                </div>
                            </div>
                            {this.state.id === null &&
                                <div className='text-right'>
                                    <button type='submit' className='btn btn-default'>Salvar</button>
                                </div>}
                        </div>
                    </div>
                </form>
                <div className='row'>
                    <div className='col-md-6'>
                        <form role='form' onSubmit={this.state.id ? this.setNewEmail : this.lookForEmail}>
                            <div className='form-group'>
                                <input ref='newEmail' name='email'
                                    type='email' className='form-control' required={true}
                                    placeholder={this.state.id ? 'Novo email' : 'Buscar por email'} />
                            </div>
                        </form>
                        {this.state.id &&
                            <ContactList list={this.state.emails} /> }
                        {this.state.id &&
                            <ContactList list={this.state.tels} /> }
                    </div>
                    <div className='col-md-6'>
                        <div className='checkbox'>
                            <label>
                                <input type='checkbox' checked={this.state.active || this.state.isAdmin} disabled={this.state.id === null || this.state.isAdmin} onChange={this.toggleUser} />
                                    Funcionário ativo
                            </label>
                        </div>
                        <div className='checkbox'>
                            <label>
                                <input type='checkbox' checked={this.state.isAdmin} disabled={this.state.id === null} onChange={this.toggleAdmin} /> Administrador
                            </label>
                        </div>
                        {this.state.id && this.state.active &&
                            <OrgApps org={this.props.org} user={this.state.id} />}
                    </div>
                </div>
            </div>;
        }
    });
    components.OrgUserManager =  React.createClass({
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

            return <div className='row'>
                <div className='col-md-3'>
                    <h5>Suas organizações</h5>
                    <OrgList uri='/admin/orgs/users'
                            selected={this.state.selectedOrg}
                            setSelected={this.setSelectedOrg} />
                </div>
                <div className='col-md-3'>
                    <h5>Usuários</h5>
                    <OrgList uri={this.state.selectedOrg.id ? '/admin/org/' + this.state.selectedOrg.id + '/users' : null}
                        selected={this.state.selectedUser}
                        forceUpdate={this.state.forceUpdate}
                        setSelected={this.setSelectedUser} />
                </div>
                <div className='col-md-6'>
                    <h5>Usuário</h5>
                    { this.state.selectedOrg.id &&
                        <UserForm
                            org={this.state.selectedOrg.id}
                            user={this.state.selectedUser}
                            setSelected={this.setSelectedUser} /> }
                </div>
            </div>;
        } 
    });
}(window, jQuery));