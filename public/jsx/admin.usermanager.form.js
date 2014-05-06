/** @jsx React.DOM */
(function (window, $) {
    "use strict";
    function Date_toYMD() {
        var year, month, day;
        year = String(this.getFullYear());
        month = String(this.getMonth() + 1);
        if (month.length === 1) {
            month = "0" + month;
        }
        day = String(this.getDate());
        if (day.length === 1) {
            day = "0" + day;
        }
        return year + "-" + month + "-" + day;
    }
    Date.prototype.toYMD = Date_toYMD;

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        SelectedUser,
        ExistingUserForm,
        ContactList,
        ContactItem,
        UserAvatar;

    UserAvatar = React.createClass({
        render: function () {
            return (<img className='userAvatarThumb' src={this.props.src ? this.props.src : '/img/user-large.png'} />);
        }
    });
    ContactItem = React.createClass({
        onCloseClick: function() {
            this.props.removeUserContact(this.props.item);
        },
        render: function(){
            return (<li className='list-group-item'>
                    <span>{this.props.item}</span>
                    { this.props.removeUserContact
                        ? <a href='#' aria-hidden="true" className="close" title="Remover" onClick={this.onCloseClick}>×</a>
                        : ''
                    }
            </li>)
        }
    });
    ContactList = React.createClass({
        render: function () {
            return (<ul className='list-group ContactList'>
                {
                    this.props.list.map(function(item){
                        return (
                            this.props.removeUserContact
                                ? <ContactItem 
                                    item={item} 
                                    key={item} 
                                    removeUserContact={this.props.removeUserContact} />
                                : <ContactItem 
                                    item={item} 
                                    key={item} />
                        );
                    }.bind(this))
                }        
            </ul>);
        }
    });
    ExistingUserForm = React.createClass({
        render: function () {
            return (<div>
                    <div className='row'>
                        <div className='col-md-5'>
                            <form role='form'>
                                <div className='form-group'>
                                    <input type='email' className='form-control' required={true} placeholder='Novo email' />
                                </div>
                            </form>
                            <ContactList list={this.props.emails} removeUserContact={this.props.removeUserContact} />
                            <ContactList list={this.props.tels} />
                        </div>
                        <div className='col-md-7'>
                            lista de empresas
                        </div>
                    </div>
                </div>);
        }
        
    });
    SelectedUser = React.createClass({
        mixins: [React.addons.LinkedStateMixin],
        setExpiration: function () {
            this.setState({expiration: (new Date()).toYMD()});
        },
        activeUserNow: function () {
            this.setState({init: (new Date()).toYMD(), disabled: false});
        },
        removeUserContact: function(email) {
            var emails = this.state.emails, index = emails.indexOf(email);
            if (index >= 0) {
                emails.splice(index, 1);
                this.setState({emails: emails});
            }
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
                wasDisabled: true
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
            $(this.getDOMNode()).find('#userSetInit').datepicker({
                
            });
        },
        render: function () {
            var userSwitch = (
                    <div className='userSwitch'>
                        <div className='form-group row'>
                            <div className='col-md-6'>
                                <label htmlFor='userSetInit'>Usuário ativado em</label>
                                <input type='text' 
                                    id='userSetInit'
                                    className='date-picker form-control' 
                                    valueLink={this.linkState('init')}
                                    readOnly={this.props.user && !this.state.wasDisabled} />
                            </div>
                            <div className='col-md-6'>
                                <label htmlFor='userSetExpiration'>Data de expiração</label>
                                    {this.state.expiration
                                        ? (<input type='text' 
                                            id='userSetExpiration'
                                            className='date-picker form-control' 
                                            valueLink={this.linkState('expiration')} />)
                                        : (<div>
                                                <input type='hidden' 
                                                    id='userSetExpiration'/>
                                                {'nunca ― '}
                                                <a href='#' onClick={this.setExpiration}>mudar</a>
                                            </div>)
                                    }
                            </div>  
                        </div>
                    <button type='submit' className="btn btn-default">Salvar</button>
                    </div>);

            if(this.state.disabled){
                userSwitch = (<div className='text-danger userSwitch'>
                    <strong>Usuário desativado, <a href='#' onClick={this.activeUserNow}>ativar</a></strong>
                </div>);
            }
            return (<div className='selectedUser jumbotron'>
                <form action={'/admin/user' + 
                        ( this.props.user 
                            ? '/' + this.props.user : '' ) + '/name'} method='POST'>
                    <div className='row'>
                        <div className='col-md-3 userAvatarThumbContainer'>
                            <span></span>
                            <UserAvatar src={this.state.avatar} />
                        </div>
                        <div className='col-md-9'>
                            <div className='row'>
                                <div className='col-md-4'>
                                    <div className='form-group'>
                                        <label htmlFor='userShortName'>Primeiro nome/apelido</label>
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
                        </div>
                    </div>
                </form>
                
                {this.props.user
                    ? (<ExistingUserForm 
                        emails={this.state.emails}
                        tels={this.state.tels}
                        removeUserContact={this.removeUserContact} />)
                    : ''
                }
            </div>);
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));