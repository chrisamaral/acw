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

    UserAvatar = React.createClass({displayName: 'UserAvatar',
        render: function () {
            return (React.DOM.img( {className:"userAvatarThumb", src:this.props.src ? this.props.src : '/img/user-large.png'} ));
        }
    });
    ContactItem = React.createClass({displayName: 'ContactItem',
        onCloseClick: function() {
            this.props.removeUserContact(this.props.item);
        },
        render: function(){
            return (React.DOM.li( {className:"list-group-item"}, 
                    React.DOM.span(null, this.props.item),
                     this.props.removeUserContact
                        ? React.DOM.a( {href:"#", 'aria-hidden':"true", className:"close", title:"Remover", onClick:this.onCloseClick}, "×")
                        : ''
                    
            ))
        }
    });
    ContactList = React.createClass({displayName: 'ContactList',
        render: function () {
            return (React.DOM.ul( {className:"list-group ContactList"}, 
                
                    this.props.list.map(function(item){
                        return (
                            this.props.removeUserContact
                                ? ContactItem( 
                                    {item:item, 
                                    key:item, 
                                    removeUserContact:this.props.removeUserContact} )
                                : ContactItem( 
                                    {item:item, 
                                    key:item} )
                        );
                    }.bind(this))
                        
            ));
        }
    });
    ExistingUserForm = React.createClass({displayName: 'ExistingUserForm',
        render: function () {
            return (React.DOM.div(null, 
                    React.DOM.div( {className:"row"}, 
                        React.DOM.div( {className:"col-md-5"}, 
                            React.DOM.form( {role:"form"}, 
                                React.DOM.div( {className:"form-group"}, 
                                    React.DOM.input( {type:"email", className:"form-control", required:true, placeholder:"Novo email"} )
                                )
                            ),
                            ContactList( {list:this.props.emails, removeUserContact:this.props.removeUserContact} ),
                            ContactList( {list:this.props.tels} )
                        ),
                        React.DOM.div( {className:"col-md-7"}, 
                            "lista de empresas"
                        )
                    )
                ));
        }
        
    });
    SelectedUser = React.createClass({displayName: 'SelectedUser',
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
                    React.DOM.div( {className:"userSwitch"}, 
                        React.DOM.div( {className:"form-group row"}, 
                            React.DOM.div( {className:"col-md-6"}, 
                                React.DOM.label( {htmlFor:"userSetInit"}, "Usuário ativado em"),
                                React.DOM.input( {type:"text", 
                                    id:"userSetInit",
                                    className:"date-picker form-control", 
                                    valueLink:this.linkState('init'),
                                    readOnly:this.props.user && !this.state.wasDisabled} )
                            ),
                            React.DOM.div( {className:"col-md-6"}, 
                                React.DOM.label( {htmlFor:"userSetExpiration"}, "Data de expiração"),
                                    this.state.expiration
                                        ? (React.DOM.input( {type:"text", 
                                            id:"userSetExpiration",
                                            className:"date-picker form-control", 
                                            valueLink:this.linkState('expiration')} ))
                                        : (React.DOM.div(null, 
                                                React.DOM.input( {type:"hidden", 
                                                    id:"userSetExpiration"}),
                                                'nunca ― ',
                                                React.DOM.a( {href:"#", onClick:this.setExpiration}, "mudar")
                                            ))
                                    
                            )  
                        ),
                    React.DOM.button( {type:"submit", className:"btn btn-default"}, "Salvar")
                    ));

            if(this.state.disabled){
                userSwitch = (React.DOM.div( {className:"text-danger userSwitch"}, 
                    React.DOM.strong(null, "Usuário desativado, ", React.DOM.a( {href:"#", onClick:this.activeUserNow}, "ativar"))
                ));
            }
            return (React.DOM.div( {className:"selectedUser jumbotron"}, 
                React.DOM.form( {action:'/admin/user' + 
                        ( this.props.user 
                            ? '/' + this.props.user : '' ) + '/name', method:"POST"}, 
                    React.DOM.div( {className:"row"}, 
                        React.DOM.div( {className:"col-md-3 userAvatarThumbContainer"}, 
                            React.DOM.span(null),
                            UserAvatar( {src:this.state.avatar} )
                        ),
                        React.DOM.div( {className:"col-md-9"}, 
                            React.DOM.div( {className:"row"}, 
                                React.DOM.div( {className:"col-md-4"}, 
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
                                React.DOM.div( {className:"col-md-8"}, 
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
                            ),
                            userSwitch
                        )
                    )
                ),
                
                this.props.user
                    ? (ExistingUserForm( 
                        {emails:this.state.emails,
                        tels:this.state.tels,
                        removeUserContact:this.removeUserContact} ))
                    : ''
                
            ));
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));