/** @jsx React.DOM */
(function (window, $) {
    "use strict";

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
                        ? <a aria-hidden="true" className="close" title="Remover" onClick={this.onCloseClick}>×</a>
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
                    <div className='userGrantLine'>usuário válido desde XXX até YYY</div>
                    <div className='row'>
                        <div className='col-md-5'>
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
                avatar: null
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
                    this.setState(user);
                }.bind(this));
        },
        render: function () {
            return (<div className='selectedUser jumbotron'>
                <form action={'/admin/user' + 
                        ( this.props.user 
                            ? '/' + this.props.user : '' ) + '/name'} method='POST'>
                    <div className='row'>
                        <div className='col-md-2 userAvatarThumbContainer'>
                            <span></span>
                            <UserAvatar src={this.state.avatar} />
                        </div>
                        <div className='col-md-3'>
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
                        <div className='col-md-7'>
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