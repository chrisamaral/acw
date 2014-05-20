/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        StdListItem,
        ContactItem,
        AlertList;

    components.ContactItem = React.createClass({displayName: 'ContactItem',
        render: function(){
            return (React.DOM.li( {className:"list-group-item"}, React.DOM.span(null, this.props.item)))
        }
    });
    ContactItem = components.ContactItem;
    components.ContactList = React.createClass({displayName: 'ContactList',
        render: function () {
            return (React.DOM.ul( {className:"list-group ContactList"}, 
                
                    this.props.list.map(function(item){
                        return (ContactItem( {item:item, key:item} ));
                    }.bind(this))
                    
            ));
        }
    });

    components.UserAvatar = React.createClass({displayName: 'UserAvatar',
        render: function () {
            return (React.DOM.img( {className:"userAvatarThumb", src:this.props.src ? this.props.src : '/img/user-large.png'} ));
        }
    });

    components.ProgressBar = React.createClass({displayName: 'ProgressBar',
        render: function () {
            var progStyle = {width: this.props.progress + '%'};
            return (React.DOM.div( {className:"progress"}, 
                React.DOM.div( {className:"progress-bar",
                role:"progressbar", 'aria-valuenow':this.props.progress,
                'aria-valuemin':"0", 'aria-valuemax':"100", style:progStyle}, 
                                this.props.progress + '%'
                )
            ));
        }
    });

    components.AlertList = React.createClass({displayName: 'AlertList',
        dismissAlert: function (e) {

            e.preventDefault();
            e.stopPropagation();

            if (this.props.dismissAlert) {
                this.props.dismissAlert($(e.currentTarget).data('alert-id'));
            }

            return false;
        },
        render: function() {
            return (
                React.DOM.div( {className:"formAlerts"}, 
                    _.map(this.props.alerts, function (alert, key) {
                        var classes = {alert: true};
                        classes['alert-' + alert[0]] = true;
                        return (
                            React.DOM.div( {key:key, className:React.addons.classSet(classes)}, 
                                React.DOM.button( {'data-alert-id':key, onClick:this.dismissAlert, type:"button", className:"close", 'aria-hidden':"true"}, "×"),
                                    alert[1]
                            ));
                    }.bind(this))
                ));
        }
    });
    AlertList = components.AlertList;

    components.StdForm = React.createClass({displayName: 'StdForm',
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function () {
            return {abbr: this.props.item.abbr, name: this.props.item.name, active: this.props.item.active, alerts: {}};
        },
        dismissAlert: function (id) {
            var new_alerts = this.state.alerts;
            delete new_alerts[id];
            this.setState({alerts: new_alerts});
        },
        onCheck: function(e){
            var input = e.currentTarget;
            this.setState({active: input.checked});
        },
        handleSubmit: function (e) {
            e.preventDefault();
            $.post(e.currentTarget.action, $(e.currentTarget).serialize())
                .done(function(id){
                    var item = _.merge({}, this.props.item, {
                        abbr: this.state.abbr,
                        name: this.state.name,
                        active: this.state.active
                    });

                    item.id = id;
                    this.props.setSelected(item, true);

                }.bind(this))
                .fail(function(xhr){

                    var new_alerts = this.state.alerts;
                    new_alerts[acw.uniqueId()] = ['danger', xhr.responseText];
                    this.setState({
                        alerts: new_alerts
                    });

                }.bind(this));
        },
        componentWillReceiveProps: function(props){
            this.setState({abbr: props.item.abbr, name: props.item.name, active: props.item.active});
        },
        render: function () {
            var notNew = this.props.item.id !== null;
            return React.DOM.form( {action:this.props.action + (notNew ? '/' + this.props.item.id : ''), role:"form", onSubmit:this.handleSubmit}, 
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4 form-group"}, 
                        React.DOM.label( {htmlFor:"itemAbbr"}, "Nome"),
                        React.DOM.input( {id:"itemAbbr", name:"abbr", maxLength:15, className:"form-control", type:"text", required:true, valueLink:this.linkState('abbr')} )
                    ),
                    React.DOM.div( {className:"col-md-8 form-group"}, 
                        React.DOM.label( {htmlFor:"itemName"}, "Descrição/Slogan/Motto"),
                        React.DOM.textarea( {id:"itemName", name:"name", rows:3, className:"form-control", maxLength:200, type:"text", required:true, valueLink:this.linkState('name')} )
                    )
                ),
                AlertList( {alerts:this.state.alerts, dismissAlert:this.dismissAlert} ),
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        React.DOM.div( {className:"checkbox"}, 
                            React.DOM.label(null, 
                                React.DOM.input( {name:"active", type:"checkbox",
                                    onChange:this.onCheck,
                                    checked:this.state.active,
                                    value:"on"} ),'Ativar ' + this.props.iname
                            )
                        )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        React.DOM.button( {className:"btn btn-default", type:"submit"}, "Salvar")
                    )
                )
            );
        }
    });

    components.StdListItem = React.createClass({displayName: 'StdListItem',
        clickItem: function (e) {
            e.preventDefault();

            if (this.props.setSelected) {
                this.props.setSelected(this.props.item);
            } else if (this.props.onClick) {
                this.props.onClick(this.props.item);
            }

        },
        render: function () {
            return React.DOM.a( {href:"#",
                className:React.addons.classSet({
                    'list-group-item': true,
                    stdListItem: true,
                    active: this.props.selected,
                    'deleted-item': !this.props.item.active
                }), onClick:this.clickItem}, 
                    React.DOM.h5( {className:"list-group-item-heading"}, this.props.item.abbr),
                    React.DOM.p( {className:"list-group-item-text"}, this.props.item.name)
            );
        }
    });
    StdListItem = components.StdListItem;

    components.StdList = React.createClass({displayName: 'StdList',
        getInitialState: function(){
            return {items: []};
        },
        reloadList: function (new_uri) {
            new_uri = new_uri === undefined ? this.props.uri : new_uri;

            if (!new_uri) {
                return this.setState({items: []});
            }

            $.get(new_uri)
                .done(function (items) {
                    this.setState({items: items});
                }.bind(this))
                .fail(function(){
                    this.setState({items: []});
                }.bind(this));
        },
        componentDidMount: function(){
            this.reloadList();
        },
        componentWillReceiveProps: function (new_props) {

            this.setState({
                items: this.state.items.map(function (item) {
                    return item.id === new_props.selected.id ? new_props.selected : item;
                })
            });

            if (new_props.uri !== this.props.uri || this.props.forceUpdate !== new_props.forceUpdate) {
                this.reloadList(new_props.uri);
            }
        },
        render: function () {
            var selected = this.props.selected;
            return (React.DOM.div( {className:"stdList list-group"}, 
                
                    this.state.items
                        .map(function (item) {
                            return (StdListItem(
                                        {key:item.id,
                                        item:item,
                                        selected:item.id === selected.id,
                                        setSelected:this.props.setSelected} ));
                        }.bind(this))
                    
            ));
        }
    });
}(window, jQuery));