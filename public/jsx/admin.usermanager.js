/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        UserList,
        UserItem,
        UserSearch;

    UserSearch = React.createClass({
        handleChange: function () {
            var checker = this.refs.activeUsersOnlyInput.getDOMNode(),
                text = this.refs.filterTextInput.getDOMNode().value,
                checked = checker.checked;

            this.props.onUserInput(text, checked);
        },
        render: function () {
            return (<form role='form'>
                    <div className='form-group'>
                        <label className='sr-only' htmlFor='UserSearchInput'>Termo de busca</label>
                        <input id='UserSearchInput' type='search' 
                            placeholder='Busque pelo Nome/Email'
                            ref='filterTextInput'
                            onChange={this.handleChange}
                            className='form-control'
                            value={this.props.filterText} />
                    </div>
                    <div className='checkbox'>
                        <label>
                            <input type='checkbox' 
                                ref='activeUsersOnlyInput'
                                disabled={!this.props.filterText.length}
                                onChange={this.handleChange}
                                checked={(this.props.filterText.length > 0) ? this.props.activeUsersOnly : true}
                                value={this.props.activeUsersOnly} />
                            Apenas usuários ativos
                        </label>
                    </div>
            </form>);
        }
    });

    UserItem = React.createClass({
        userClick: function(e){
            e.preventDefault();
            this.props.onUserClick(this.props.user.id);
        },
        render: function () {
            var user = this.props.user,
                label = user.full_name || user.short_name || 'sem nome ...',
                classes = React.addons.classSet({
                    'list-group-item': true,
                    stdListItem: true,
                    deleted: (user.active === 0),
                    theOne: this.props.isSelected
                });

            label = this.props.isSelected ? '❯ ' + label : label;
            return (<a href='#' onClick={this.userClick} className={classes}>{label}</a>);
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

                }.bind(this), 1000);
            },
            render: function () {
                var theOne = this.props.selectedUser;
                return (
                    <div className='stdList list-group'>
                        {theOne ?
                            (<div className='selected'>
                                <UserItem
                                    key={theOne.id} user={theOne}
                                    onUserClick={this.props.onUserClick}
                                    isSelected={true} />
                            </div>)
                        : ''}
                        <div className='others' ref='userList' onScroll={this.scrollChange}>
                            {this.props.users.map(function(user, index){
                                return (<UserItem
                                    key={user.id} user={user}
                                    onUserClick={this.props.onUserClick}
                                    isSelected={false} />);
                            }.bind(this))}
                        </div>
                    </div>
                )
            }
        });
    }());

    (function(){
        var userInputTimeout, scrollTimeout, SelectedUser;
        components.UserManager =  React.createClass({
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
            onUserUpdate: function(userID){
                userID = userID && userID.length ? userID : null;
                if (userID) {
                    this.setState({selectedUser: userID});
                }
                this.reloadList();
            },
            selectUser: function(userID){
                userID = this.state.selectedUser === userID ? null : userID;
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
                userInputTimeout = setTimeout(function () {
                    this.reloadList();
                }.bind(this), 500);
                
            },
            reloadList: function(){
                var oldOffset = this.state.query.offset, query = _.merge({}, this.state.query);
                if (this.state.selectedUser) {
                    query.user = this.state.selectedUser;
                }
                $.get('/admin/users', query)
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
                var form = '...', selected = this.state.selectedUser;
                if (this.state.formLoaded) {
                    SelectedUser = components.SelectedUser;
                    form = (<SelectedUser user={this.state.selectedUser} selectUser={this.onUserUpdate} />);
                }
                return (<div className='row userTabWrapper'>
                    <div className='col-md-4'>
                        <UserSearch 
                            activeUsersOnly={this.state.query.activeUsersOnly} 
                            filterText={this.state.query.filterText}
                            onUserInput={this.searchInputChange} />
                        <UserList 
                            users={this.state.users.filter(function(user){
                                return user.id !== selected;
                            })}
                            selectedUser={this.state.users.filter(function(user){
                                return user.id === selected;
                            })[0]}
                            onUserClick={this.selectUser}
                            onOffsetChange={this.offsetChange} 
                            reachedTop={this.state.reachedTop}
                            reachedBottom={this.state.reachedBottom} />
                    </div>
                    <div className='col-md-8'>
                        {form}
                    </div>
                </div>);
            } 
        });
    }());

}(window, jQuery));