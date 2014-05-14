/** @jsx React.DOM */
(function (window, $) {
    "use strict";
    function date_toDMY(d) {
        var year, month, day;
        year = String(d.getFullYear());
        month = String(d.getMonth() + 1);
        if (month.length === 1) {
            month = "0" + month;
        }
        day = String(d.getDate());
        if (day.length === 1) {
            day = "0" + day;
        }
        return day + '/' + month + '/' + year;
    }
    function dMY_toDate(str) {
        var ds = str.split('/');
        return new Date(
            parseInt(ds[2], 10),
            parseInt(ds[1], 10) - 1,
            parseInt(ds[0], 10),
            0,
            0,
            0
        );
    }

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        SelectedUser,
        ExistingUserForm,
        ContactList = components.ContactList,
        ContactItem = components.ContactItem,
        UserAvatar = components.UserAvatar;

    ExistingUserForm = React.createClass({
        setNewEmail: function (e) {
            e.preventDefault();
            var input = this.refs.newEmail.getDOMNode();
            this.props.newUserEmail(input.value);
            input.value = '';
        },
        render: function () {
            return <div className='ExistingUserForm'>
                <div className='row'>
                    <div className='col-md-5'>
                        <form role='form' onSubmit={this.setNewEmail}>
                            <div className='form-group'>
                                <input ref='newEmail' name='email'
                                    type='email' className='form-control' required={true} placeholder='Novo email' />
                            </div>
                        </form>
                        <ContactList list={this.props.emails} />
                        <ContactList list={this.props.tels} />
                    </div>
                    <div className='col-md-7'>
                        lista de empresas
                    </div>
                </div>
            </div>;
        }
        
    });
    SelectedUser = React.createClass({
        mixins: [React.addons.LinkedStateMixin],
        submitUserChanges: function(e){
            var form = e.currentTarget, b = this.refs.submitUserChanges.getDOMNode();
            b.disabled = true;
            $.post(form.action, $(form).serialize(), 'text')
                .done(function(newID){
                    this.props.selectUser(newID);
                }.bind(this)).always(function(){
                    b.disabled = false;
                });
            e.preventDefault();
        },
        setAdmin: function(e){
            this.setState({isAdmin: e.currentTarget.checked});
        },
        newUserEmail: function (newEmail) {
            this.setState({emails: this.state.emails.concat([newEmail])});
            $.post('/admin/user/' + this.props.user + '/email', {email: newEmail});
        },
        setExpiration: function (e) {
            e.preventDefault();
            this.setState({
                expiration: date_toDMY(new Date())
            });
        },
        activeUserNow: function (e) {
            e.preventDefault();
            this.setState({
                init: date_toDMY(new Date()),
                disabled: false
            });
        },
        disableUserNow: function () {
            this.setState({
                expiration: date_toDMY(new Date()),
                disabled: true
            });
        },
        getInitialState: function () {
            return {
                full_name: '',
                short_name: '',
                emails: [],
                tels: [],
                avatar: null,
                init: null,
                expiration: null,
                disabled: true,
                wasDisabled: true,
                isAdmin: false
            };
        },
        componentWillReceiveProps: function(new_props){
            this.loadUser(new_props);
        },
        loadUser: function (new_props) {
            if (!new_props.user) {
                return this.setState(this.getInitialState());
            }
            
            $.get('/admin/user/' + new_props.user)
                .done(function (user) {
                    user.disabled = user.init === null;
                    user.wasDisabled = user.disabled;
                    this.setState(user);
                }.bind(this));
        },
        componentDidUpdate: function () {
            if (this.state.disabled) {
                return;
            }
            var self = this;
            function setDatePickers(){
                if (self.state.disabled || !self.state.expiration) {
                    return;
                }

                $('#setUserExpiration').datepicker({
                    format: 'dd/mm/yyyy',
                    startDate: new Date()
                });
            }
            
            if ($.fn.datepicker) {
                return setDatePickers();
            }

            LazyLoad.css(['/js/ext/bootstrap-datepicker/datepicker.css']);
            LazyLoad.js(['/js/ext/bootstrap-datepicker/js/bootstrap-datepicker.min.js'], setDatePickers);
            
        },
        render: function () {
            var userSwitch = (
                    <div className='userSwitch'>
                        <div className='form-group row'>
                            <div className='col-md-6'>
                                <label>Usuário ativado em</label>
                                <p type='text' className='form-control-static'>{this.state.init}</p>
                            </div>
                            <div className='col-md-6'>
                                <label htmlFor='setUserExpiration'>Data de expiração</label>
                                    {this.state.expiration
                                        ? (<div className='input-group'>
                                                <input type='text'
                                                    name='expiration'
                                                    valueLink={this.linkState('expiration')}
                                                    id='setUserExpiration'
                                                    className='date-picker form-control'  />
                                                <span className="input-group-btn">
                                                    <button onClick={this.disableUserNow}
                                                        className="btn btn-danger" type="button">Desativar</button>
                                                </span>
                                          </div>)
                                        : (<p>
                                                <input type='hidden' 
                                                    name='expiration'
                                                    value={null}
                                                    id='setUserExpiration'/>
                                                {'nunca ― '}
                                                <a href='#' onClick={this.setExpiration}>mudar</a>
                                            </p>)
                                    }
                            </div>  
                        </div>
                    </div>);

            if(this.state.disabled){
                userSwitch = (<p className='text-danger userSwitch'>
                    <strong>Usuário desativado, <a href='#' onClick={this.activeUserNow}>ativar</a></strong>
                </p>);
            }
            return (<div className='selectedUser jumbotron'>
                <form onSubmit={this.submitUserChanges} action={'/admin/user' + 
                        ( this.props.user 
                            ? '/' + this.props.user : '' ) } method='POST'>
                    <div className='row'>
                        <div className='col-md-3 userAvatarThumbContainer'>
                            <span></span>
                            <UserAvatar src={this.state.avatar} />
                        </div>
                        <div className='col-md-9'>
                            <div className='row'>
                                <div className='col-md-4'>
                                    <div className='form-group'>
                                        <label htmlFor='userShortName'>Nome</label>
                                        <input id='userShortName'
                                            name='short_name' 
                                            className='form-control'
                                            type='text' required={true} 
                                            readOnly={this.props.user !== null}
                                            valueLink={this.linkState('short_name')} />
                                    </div>
                                </div>
                                <div className='col-md-8'>
                                    <div className='form-group'>
                                        <label htmlFor='userFullName'>Completo</label>
                                        <input id='userFullName'
                                            name='full_name' 
                                            className='form-control'
                                            type='text' required={true} 
                                            readOnly={this.props.user !== null}
                                            valueLink={this.linkState('full_name')} />
                                    </div>
                                </div>
                            </div>
                            {userSwitch}
                            <div className='row'>
                                <div className='col-md-8'>
                                    <div className='checkbox'>
                                        <label>
                                            <input type='checkbox'
                                                disabled={this.state.disabled}
                                                name='isAdmin' value='on'
                                                onChange={this.setAdmin}
                                                checked={!this.state.disabled && this.state.isAdmin} />Administrador
                                        </label>
                                    </div>
                                </div>
                                <div className='col-md-4'>
                                    <button ref='submitUserChanges' type='submit' className="btn btn-default">Salvar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                
                {this.props.user
                    ? (<ExistingUserForm 
                            newUserEmail={this.newUserEmail}
                            emails={this.state.emails}
                            tels={this.state.tels} />)
                    : ''
                }
            </div>);
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));