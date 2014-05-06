/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        UserList,
        UserItem,
        UserSearch;

    UserSearch = React.createClass({displayName: 'UserSearch',
        handleChange: function () {
            var checker = this.refs.activeUsersOnlyInput.getDOMNode(),
                text = this.refs.filterTextInput.getDOMNode().value,
                checked = checker.checked;

            this.props.onUserInput(text, checked);
        },
        render: function () {
            return (React.DOM.form( {role:"form"}, 
                    React.DOM.div( {className:"form-group"}, 
                        React.DOM.label( {className:"sr-only", htmlFor:"UserSearchInput"}, "Termo de busca"),
                        React.DOM.input( {id:"UserSearchInput", type:"search", 
                            placeholder:"Busque pelo Nome/Email",
                            ref:"filterTextInput",
                            onChange:this.handleChange,
                            className:"form-control",
                            value:this.props.filterText} )
                    ),
                    React.DOM.div( {className:"checkbox"}, 
                        React.DOM.label(null, 
                            React.DOM.input( {type:"checkbox", 
                                ref:"activeUsersOnlyInput",
                                disabled:!this.props.filterText.length,
                                onChange:this.handleChange,
                                checked:(this.props.filterText.length > 0) ? this.props.activeUsersOnly : true,
                                value:this.props.activeUsersOnly} ),
                            "Apenas usuários ativos"
                        )
                    )
            ));
        }
    });

    UserItem = React.createClass({displayName: 'UserItem',
        userClick: function(e){
            e.preventDefault();
            this.props.onUserClick(this.props.user.id);
        },
        render: function () {
            var user = this.props.user,
                label = user.full_name || user.short_name || 'sem nome ...';
            
            label = (user.active === 0) ? (React.DOM.del( {title:"Usuário desativado"}, label)) : label;
            label = this.props.isSelected 
                ? (React.DOM.strong(null, 
                        React.DOM.span( {className:"theOne"}, '❯'),
                        label
                    ))
                : label;

            return (React.DOM.a( {href:"#", onClick:this.userClick, className:"list-group-item userListItem"}, label));
        }
    });
    
    (function(){
        var scrollTimeout;
        UserList = React.createClass({displayName: 'UserList',
            scrollChange: function (e) {
                var list = this.refs.userList.getDOMNode();
                clearTimeout(scrollTimeout);
                scrollTimeout = setTimeout(function(){
                    var newScroll = list.scrollTop, scrollCorrect = list.scrollHeight * (1/10);
                    
                    if (newScroll < 10) {
                        this.props.onOffsetChange('up');
                        if (!this.props.reachedTop) {
                            $(list).animate({scrollTop: newScroll + scrollCorrect});
                        }

                    }

                    if (list.scrollHeight - (newScroll + $(list).height()) < 10) {
                        this.props.onOffsetChange('down');
                        if (!this.props.reachedBottom) {
                            $(list).animate({scrollTop: newScroll - scrollCorrect});
                        }
                    }

                }.bind(this), 1000);
            },
            render: function () {
                return (
                    React.DOM.div( {className:"userList list-group", ref:"userList", onScroll:this.scrollChange}, 
                        this.props.users.map(function(user, index){
                            return (UserItem( 
                                {key:user.id, user:user, 
                                onUserClick:this.props.onUserClick,
                                isSelected:this.props.selectedUser === user.id} ));
                        }.bind(this))
                    )
                )
            }
        });
    }());

    (function(){
        var userInputTimeout, scrollTimeout, SelectedUser;
        components.UserManager =  React.createClass({displayName: 'UserManager',
            getInitialState: function () {
                return {
                    users: [],
                    formLoaded: false,
                    selectedUser: null,
                    reachedBottom: false,
                    reachedTop: true,
                    query: {
                        filterText: '',
                        activeUsersOnly: true,
                        offset: 0
                    }
                };
            },
            selectUser: function(userID){
                this.setState({selectedUser: userID});
            },
            componentDidMount: function () {
                var js = ['/js/' + window.jsPath + '/admin.usermanager.form.js'];
                
                LazyLoad.js(js, function(){
                    this.setState({formLoaded: true});
                    this.reloadList();
                }.bind(this));
                
            },
            offsetChange: function(dir){
                var oldOffset = this.state.query.offset, 
                    newOffset = 
                    (oldOffset < 10 && dir === 'up') ? 0
                        : dir === 'up' ? oldOffset - 10 : oldOffset + 10;
                
                if (oldOffset === newOffset) {
                    return;
                }

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

                clearTimeout(userInputTimeout);
                userInputTimeout = setTimeout(function(){
                    this.reloadList();
                }.bind(this), 500);
                
            },
            reloadList: function(){
                var oldOffset = this.state.query.offset;
                $.get('/admin/users', this.state.query)
                    .done(function (response) {

                        this.setState({
                            users: response.users,
                            reachedTop: (response.offset === 0),
                            reachedBottom: (response.offset < oldOffset),
                            query: _.merge(this.state.query, {
                                offset: response.offset
                            })
                        });
                    }.bind(this));
            },
            render: function () {
                var form = '...';
                if (this.state.formLoaded) {
                    SelectedUser = components.SelectedUser;
                    form = (SelectedUser( {user:this.state.selectedUser}));
                }
                return (React.DOM.div( {className:"row userTabWrapper"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        UserSearch( 
                            {activeUsersOnly:this.state.query.activeUsersOnly, 
                            filterText:this.state.query.filterText,
                            onUserInput:this.searchInputChange} ),
                        UserList( 
                            {users:this.state.users, 
                            selectedUser:this.state.selectedUser,
                            onUserClick:this.selectUser,
                            onOffsetChange:this.offsetChange, 
                            reachedTop:this.state.reachedTop,
                            reachedBottom:this.state.reachedBottom} )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        form
                    )
                ));
            } 
        });
    }());

}(window, jQuery));