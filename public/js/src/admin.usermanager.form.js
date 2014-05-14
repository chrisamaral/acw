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

    ExistingUserForm = React.createClass({displayName: 'ExistingUserForm',
        setNewEmail: function (e) {
            e.preventDefault();
            var input = this.refs.newEmail.getDOMNode();
            this.props.newUserEmail(input.value);
            input.value = '';
        },
        render: function () {
            return React.DOM.div( {className:"ExistingUserForm"}, 
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-5"}, 
                        React.DOM.form( {role:"form", onSubmit:this.setNewEmail}, 
                            React.DOM.div( {className:"form-group"}, 
                                React.DOM.input( {ref:"newEmail", name:"email",
                                    type:"email", className:"form-control", required:true, placeholder:"Novo email"} )
                            )
                        ),
                        ContactList( {list:this.props.emails} ),
                        ContactList( {list:this.props.tels} )
                    ),
                    React.DOM.div( {className:"col-md-7"}, 
                        "lista de empresas"
                    )
                )
            );
        }
        
    });
    SelectedUser = React.createClass({displayName: 'SelectedUser',
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
            LazyLoad.js(['/js/ext/bootstrap-datepicker/js/bootstrap-datepicker.js'], setDatePickers);
            
        },
        render: function () {
            var userSwitch = (
                    React.DOM.div( {className:"userSwitch"}, 
                        React.DOM.div( {className:"form-group row"}, 
                            React.DOM.div( {className:"col-md-6"}, 
                                React.DOM.label(null, "Usuário ativado em"),
                                React.DOM.p( {type:"text", className:"form-control-static"}, this.state.init)
                            ),
                            React.DOM.div( {className:"col-md-6"}, 
                                React.DOM.label( {htmlFor:"setUserExpiration"}, "Data de expiração"),
                                    this.state.expiration
                                        ? (React.DOM.div( {className:"input-group"}, 
                                                React.DOM.input( {type:"text",
                                                    name:"expiration",
                                                    valueLink:this.linkState('expiration'),
                                                    id:"setUserExpiration",
                                                    className:"date-picker form-control"}  ),
                                                React.DOM.span( {className:"input-group-btn"}, 
                                                    React.DOM.button( {onClick:this.disableUserNow,
                                                        className:"btn btn-danger", type:"button"}, "Desativar")
                                                )
                                          ))
                                        : (React.DOM.p(null, 
                                                React.DOM.input( {type:"hidden", 
                                                    name:"expiration",
                                                    value:null,
                                                    id:"setUserExpiration"}),
                                                'nunca ― ',
                                                React.DOM.a( {href:"#", onClick:this.setExpiration}, "mudar")
                                            ))
                                    
                            )  
                        )
                    ));

            if(this.state.disabled){
                userSwitch = (React.DOM.p( {className:"text-danger userSwitch"}, 
                    React.DOM.strong(null, "Usuário desativado, ", React.DOM.a( {href:"#", onClick:this.activeUserNow}, "ativar"))
                ));
            }
            return (React.DOM.div( {className:"selectedUser jumbotron"}, 
                React.DOM.form( {onSubmit:this.submitUserChanges, action:'/admin/user' + 
                        ( this.props.user 
                            ? '/' + this.props.user : '' ),  method:"POST"}, 
                    React.DOM.div( {className:"row"}, 
                        React.DOM.div( {className:"col-md-3 userAvatarThumbContainer"}, 
                            React.DOM.span(null),
                            UserAvatar( {src:this.state.avatar} )
                        ),
                        React.DOM.div( {className:"col-md-9"}, 
                            React.DOM.div( {className:"row"}, 
                                React.DOM.div( {className:"col-md-4"}, 
                                    React.DOM.div( {className:"form-group"}, 
                                        React.DOM.label( {htmlFor:"userShortName"}, "Nome"),
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
                            userSwitch,
                            React.DOM.div( {className:"row"}, 
                                React.DOM.div( {className:"col-md-8"}, 
                                    React.DOM.div( {className:"checkbox"}, 
                                        React.DOM.label(null, 
                                            React.DOM.input( {type:"checkbox",
                                                disabled:this.state.disabled,
                                                name:"isAdmin", value:"on",
                                                onChange:this.setAdmin,
                                                checked:!this.state.disabled && this.state.isAdmin} ),"Administrador"
                                        )
                                    )
                                ),
                                React.DOM.div( {className:"col-md-4"}, 
                                    React.DOM.button( {ref:"submitUserChanges", type:"submit", className:"btn btn-default"}, "Salvar")
                                )
                            )
                        )
                    )
                ),
                
                this.props.user
                    ? (ExistingUserForm( 
                            {newUserEmail:this.newUserEmail,
                            emails:this.state.emails,
                            tels:this.state.tels} ))
                    : ''
                
            ));
        }
    });
    components.SelectedUser = SelectedUser;
}(window, jQuery));