/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        SelectedUser,
        UserAvatar;

    UserAvatar = React.createClass({
        render: function () {
            return (<img className='userAvatarThumb' src={this.props.src ? this.props.src : '/img/user-large.png'} />);
        }
    });
    SelectedUser = React.createClass({
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function () {
            return {
                id: null,
                full_name: '',
                short_name: '',
                emails: [],
                tels: [],
                avatar: null
            };
        },
        componentDidMount: function(){
            console.log('mounted again');
        },
        loadUser: function () {

            if (this.props.user === this.state.id) {
                return;
            }

            if (!this.props.user) {
                return setTimeout(function(){
                    this.setState(this.getInitialState());
                }.bind(this), 100);
            }

            
            $.get(this.props.action + '/' + this.props.user)
                .done(function (user) {
                    this.setState(user);
                }.bind(this));
        },
        render: function () {
            this.loadUser();
            return (<div className='selectedUser jumbotron'>
                <form action={this.props.user 
                            ? this.props.action + '/' + this.props.user 
                            : this.props.action} 
                        data-user-id={this.props.user}
                        method='POST'>
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
            </div>);
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));