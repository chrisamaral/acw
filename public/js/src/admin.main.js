/** @jsx React.DOM */
(function (window, $) {
    "use strict";
    window.acw = window.acw || {};
    var components = {}, React = window.React, Tab, TabContent, AdminTabs, acw = window.acw;

    TabContent = React.createClass({displayName: 'TabContent',
        render: function () {
            var tab = this.props.tab, TabComponent = components[tab.id],
                classes = React.addons.classSet({"tab-pane": true, active: this.props.active});
            return (React.DOM.div( {id:tab.id, className:classes}, TabComponent( {tab:tab} )));
        } 
    });

    Tab = React.createClass({displayName: 'Tab',
        render: function () {
            var tab = this.props.tab,
                classes = React.addons.classSet({active: this.props.active});

            return (React.DOM.li( {className:classes}, React.DOM.a( {href:'#' + tab.id, 'data-toggle':"tab"}, tab.title)));
        } 
    });

    AdminTabs = React.createClass({displayName: 'AdminTabs',
        getInitialState: function () {
            return {tabs: [], user: null};
        },
        componentDidMount: function () {
            $.get(this.props.source)
                .done(function (response) {
                    acw.user = response.user;
                    var jsFiles = ['/js/' + window.jsPath + '/admin.shared.js'];

                    jsFiles = jsFiles.concat(
                        response.tabs.map(function(tab){
                            return '/js/' + window.jsPath + '/admin.' + tab.id.toLowerCase() + '.js';
                        })
                    );

                    LazyLoad.js(jsFiles, function(){
                        this.setState({tabs: response.tabs, user: response.user});
                    }.bind(this));
                }.bind(this));
        },
        render: function () {
            var tabs = [], divs = [];

            this.state.tabs.forEach(function (tab) {
                var active = tabs.length === 0;
                tabs.push(Tab( {key:tab.id, tab:tab, active:active} ));
                divs.push(TabContent( {key:tab.id, tab:tab, active:active} ));
            });

            return (
                React.DOM.div(null, 
                    React.DOM.ul( {className:"nav nav-tabs"}, 
                        tabs
                    ),
                    React.DOM.div( {className:"tab-content"}, 
                        divs
                    )
                )
            );
        }
    });

    acw.components = components;
    components.AdminTabs = AdminTabs;

    function render(){
        React.renderComponent(AdminTabs( {source:"/admin/tabs"} ), $('.contentWrapper')[0]);
    }
    
    LazyLoad.js([
        '//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js',
        '//cdnjs.cloudflare.com/ajax/libs/pace/0.4.17/pace.min.js'], render);
    LazyLoad.css(['/css/pace.css']);
}(window, jQuery));