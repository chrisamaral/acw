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

    SelectedUser = React.createClass({
        render: function () {
            return (<div className='selectedUser'>
                <form action='/admin/user' method='POST'>
                    the form goes here
                </form>
            </div>);
        }
    });

    UserSearch = React.createClass({
        handleChange: function () {
            
            var checker = this.refs.activeUsersOnlyInput.getDOMNode(),
                text = this.refs.filterTextInput.getDOMNode().value,
                checked = checker.checked;

            this.props.onUserInput(text, checked);
        },
        render: function () {
            return (<form onSubmit={this.handleSubmit}>
                <input type='search' 
                    placeholder='Busque pelo Nome/Email'
                    ref='filterTextInput'
                    onChange={this.handleChange}
                    value={this.props.filterText} />
                <p className='userSearchToggle'>
                    <label htmlFor='UserSearchFilterToggle'>
                        <input id='UserSearchFilterToggle' type='checkbox' 
                            ref='activeUsersOnlyInput'
                            disabled={!this.props.filterText.length}
                            onChange={this.handleChange}
                            checked={(this.props.filterText.length > 0) ? this.props.activeUsersOnly : true}
                            value={this.props.activeUsersOnly} />
                        <span>Apenas usuários ativos</span>
                    </label>
                </p>
            </form>);
        }
    });

    UserItem = React.createClass({
        render: function () {
            var user = this.props.user,
                label = user.full_name || user.short_name || 'sem nome ...';
            label = (user.active === 0) ? (<del title='Usuário desativado'>{label}</del>) : label;
            return (<a href='#' className='list-group-item'>{label}</a>);
        }
    });
    
    (function(){
        var scrollTimeout;
        UserList = React.createClass({
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

                }.bind(this), 500);
            },
            render: function () {
                var users = [];
                this.props.users.forEach(function(user, index){
                    users.push(<UserItem key={user.id} user={user} />);
                });
                return (
                    <div className='userList list-group' ref='userList' onScroll={this.scrollChange}>
                        {users}
                    </div>
                )
            }
        });
    }());

    (function(){
        var userInputTimeout, scrollTimeout;
        components.UserManager =  React.createClass({
            getInitialState: function () {
                return {users: [], selectedUser: null, reachedBottom: false, reachedTop: true,
                    query: {
                        filterText: '', activeUsersOnly: true, offset: 0
                    }
                };
            },
            componentDidMount: function () {
                this.reloadList();
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
                return (<div className='row userTabWrapper'>
                    <div className='col-md-4'>
                        <UserSearch 
                            activeUsersOnly={this.state.query.activeUsersOnly} 
                            filterText={this.state.query.filterText}
                            onUserInput={this.searchInputChange} />
                        <UserList 
                            users={this.state.users} 
                            onOffsetChange={this.offsetChange} 
                            reachedTop={this.state.reachedTop}
                            reachedBottom={this.state.reachedBottom} />
                    </div>
                    <div className='col-md-8'>
                        <SelectedUser user={this.state.selectedUser}/>
                    </div>
                </div>);
            } 
        });
    }());

}(window, jQuery));