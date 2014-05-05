/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        SelectedUser,
        UserAvatar;

    UserAvatar = React.createClass({displayName: 'UserAvatar',
        render: function () {
            return (React.DOM.img( {className:"userAvatarThumb", src:this.props.src ? this.props.src : '/img/user-large.png'} ));
        }
    });
    SelectedUser = React.createClass({displayName: 'SelectedUser',
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
            return (React.DOM.div( {className:"selectedUser jumbotron"}, 
                React.DOM.form( {action:this.props.user 
                            ? this.props.action + '/' + this.props.user 
                            : this.props.action, 
                        'data-user-id':this.props.user,
                        method:"POST"}, 
                    React.DOM.div( {className:"row"}, 
                        React.DOM.div( {className:"col-md-2 userAvatarThumbContainer"}, 
                            React.DOM.span(null),
                            UserAvatar( {src:this.state.avatar} )
                        ),
                        React.DOM.div( {className:"col-md-3"}, 
                            React.DOM.div( {className:"form-group"}, 
                                React.DOM.label( {htmlFor:"userShortName"}, "Primeiro nome/apelido"),
                                React.DOM.input( {id:"userShortName",
                                    name:"short_name", 
                                    className:"form-control",
                                    type:"text", required:true, 
                                    readOnly:this.props.user !== null,
                                    valueLink:this.linkState('short_name')} )
                            )
                        ),
                        React.DOM.div( {className:"col-md-7"}, 
                            React.DOM.div( {className:"form-group"}, 
                                React.DOM.label( {htmlFor:"userFullName"}, "Completo"),
                                React.DOM.input( {id:"userFullName",
                                    name:"full_name", 
                                    className:"form-control",
                                    type:"text", required:true, 
                                    readOnly:this.props.user !== null,
                                    valueLink:this.linkState('full_name')} )
                            )
                        )
                    )
                )
            ));
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));