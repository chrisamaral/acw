/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    window.acw = window.acw || {};

    var components = {}, React = window.React, Tab, TabContent, AdminTabs, acw = window.acw;

    acw.uniqueId = function(){
        return String.fromCharCode(65 + Math.floor(Math.random() * 26)).toLowerCase() + Date.now().toString(36);
    };

    TabContent = React.createClass({
        render: function () {
            var tab = this.props.tab,
                TabComponent,
                classes = React.addons.classSet(
                    {"tab-pane": true, active: this.props.active}
                );

            if (this.props.tab.active && !this.props.tab.onLoadGet) {

                TabComponent = components[tab.id];
                return <div id={tab.id} className={classes}>
                    <TabComponent tab={tab} />
                </div>;

            } else {
                return <div id={tab.id} className={classes}>...</div>;
            }
        }
    });

    Tab = React.createClass({
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({active: this.props.active});

            return <li className={classes}>
                <a href={'#' + tab.id} data-toggle='tab' data-id={tab.id}>{tab.title}</a>
            </li>;
        } 
    });

    AdminTabs = React.createClass({
        getInitialState: function () {
            return {tabs: {}, user: null, bound: false};
        },
        componentDidMount: function () {
            $.get(this.props.source)
                .done(function (response) {
                    acw.user = response.user;
                    var jsFiles = ['/js/' + window.jsPath + '/admin.shared.js'], tabs = {}, activeTab;

                    response.tabs.forEach(function (tab, index) {
                        tab.active = index === 0;
                        tab.onLoadGet = function() {
                            var self = this.component, tabs = self.state.tabs, tab = tabs[this.tab];

                            LazyLoad.js('/js/' + window.jsPath + '/admin.' + tab.id.toLowerCase() + '.js', function () {
                                tab.onLoadGet = null;
                                self.setState({tabs: tabs});
                            });

                        }.bind({component: this, tab: tab.id});
                        tabs[tab.id] = tab;
                        if (tab.active) {
                            activeTab = tab;
                        }
                    }.bind(this));


                    LazyLoad.js(jsFiles, function(){
                        this.setState({tabs: tabs, user: response.user});
                        activeTab.onLoadGet();
                    }.bind(this));
                }.bind(this));
        },
        handleTabChange: function (e) {

            var id = $(e.target).data('id'),
                tabs = {};

            _.forEach(this.state.tabs, function (tab) {
                tab.active = tab.id === id;
                tabs[tab.id] = tab;
            });

            if (tabs[id].onLoadGet) {
                tabs[id].onLoadGet();
            } else {
                this.setState({tabs: tabs});
            }
        },
        componentDidUpdate: function(){
            var elem = this.getDOMNode();

            if (!this.state.bound) {
                $(elem).find('a[data-toggle="tab"]').on('shown.bs.tab', this.handleTabChange);
                this.setState({bound: true});
            }
        },
        render: function () {
            var tabs = [], divs = [];

            _.forEach(this.state.tabs, function (tab) {
                tabs.push(<Tab key={tab.id} tab={tab} active={tab.active} />);
                divs.push(<TabContent key={tab.id} tab={tab} active={tab.active} />);
            });

            return (
                <div>
                    <ul className="nav nav-tabs">
                        {tabs}
                    </ul>
                    <div className="tab-content">
                        {divs}
                    </div>
                </div>
            );
        }
    });

    acw.components = components;
    components.AdminTabs = AdminTabs;

    function render(){
        React.renderComponent(<AdminTabs source="/admin/tabs" />, $('.contentWrapper')[0]);
    }
    
    render();
}(window, jQuery));