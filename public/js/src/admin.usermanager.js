/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        UserList,
        UserItem,
        SelectedUser,
        UserSearch;

    SelectedUser = React.createClass({displayName: 'SelectedUser',
        render: function () {
            return (React.DOM.div( {className:"selectedUser"}, 
                React.DOM.form( {action:"/admin/user", method:"POST"}, 
                    "the form goes here"
                )
            ));
        }
    });

    UserSearch = React.createClass({displayName: 'UserSearch',
        handleChange: function () {
            
            var checker = this.refs.activeUsersOnlyInput.getDOMNode(),
                text = this.refs.filterTextInput.getDOMNode().value,
                checked = checker.checked;

            this.props.onUserInput(text, checked);
        },
        render: function () {
            return (React.DOM.form( {onSubmit:this.handleSubmit}, 
                React.DOM.input( {type:"search", 
                    placeholder:"Busque pelo Nome/Email",
                    ref:"filterTextInput",
                    onChange:this.handleChange,
                    value:this.props.filterText} ),
                React.DOM.p( {className:"userSearchToggle"}, 
                    React.DOM.label( {htmlFor:"UserSearchFilterToggle"}, 
                        React.DOM.input( {id:"UserSearchFilterToggle", type:"checkbox", 
                            ref:"activeUsersOnlyInput",
                            disabled:!this.props.filterText.length,
                            onChange:this.handleChange,
                            checked:(this.props.filterText.length > 0) ? this.props.activeUsersOnly : true,
                            value:this.props.activeUsersOnly} ),
                        React.DOM.span(null, "Apenas usuários ativos")
                    )
                )
            ));
        }
    });

    UserItem = React.createClass({displayName: 'UserItem',
        render: function () {
            var user = this.props.user,
                label = user.full_name || user.short_name || 'sem nome ...';
            return (React.DOM.a( {href:"#", className:"list-group-item"}, label));
        }
    });

    UserList = React.createClass({displayName: 'UserList',
        render: function () {
            var users = [];
            this.props.users.forEach(function(user, index){
                users.push(UserItem( {key:user.id, user:user} ));
            });
            return (
                React.DOM.div( {className:"userList list-group"}, 
                    users
                )
            )
        }
    });
    components.UserManager =  React.createClass({displayName: 'UserManager',
        getInitialState: function () {
            return {users: [], selectedUser: null, 
                query: {
                    filterText: '', activeUsersOnly: true, offset: 0
                }
            };
        },
        componentDidMount: function () {
            this.reloadList();
        },
        offsetChange: function(newOffset){
            this.setState({query: _.merge(
                this.state.query, {offset: newOffset})});
            this.reloadList();
        },
        searchInputChange: function (filterText, activeUsersOnly) {
            this.setState({query:
                _.merge(this.state.query, {
                    filterText: filterText, 
                    activeUsersOnly: (filterText.length > 0) ? activeUsersOnly : true
                })});
            this.reloadList();
        },
        reloadList: function(offset, filterText, activeUsersOnly){

            $.get('/admin/users', this.state.query)
                .done(function (response) {
                    this.setState({users: response});
                }.bind(this));
        },
        render: function () {
            return (React.DOM.div( {className:"row userTabWrapper"}, 
                React.DOM.div( {className:"col-md-4"}, 
                    UserSearch( 
                        {activeUsersOnly:this.state.query.activeUsersOnly, 
                        filterText:this.state.query.filterText,
                        onUserInput:this.searchInputChange} ),
                    UserList( {users:this.state.users} )
                ),
                React.DOM.div( {className:"col-md-8"}, 
                    SelectedUser( {user:this.state.selectedUser})
                )
            ));
        } 
    });
}(window, jQuery));