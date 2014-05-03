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
            return (<a href='#' className='list-group-item'>{label}</a>);
        }
    });

    UserList = React.createClass({
        render: function () {
            var users = [];
            this.props.users.forEach(function(user, index){
                users.push(<UserItem key={user.id} user={user} />);
            });
            return (
                <div className='userList list-group'>
                    {users}
                </div>
            )
        }
    });
    components.UserManager =  React.createClass({
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
            return (<div className='row userTabWrapper'>
                <div className='col-md-4'>
                    <UserSearch 
                        activeUsersOnly={this.state.query.activeUsersOnly} 
                        filterText={this.state.query.filterText}
                        onUserInput={this.searchInputChange} />
                    <UserList users={this.state.users} />
                </div>
                <div className='col-md-8'>
                    <SelectedUser user={this.state.selectedUser}/>
                </div>
            </div>);
        } 
    });
}(window, jQuery));