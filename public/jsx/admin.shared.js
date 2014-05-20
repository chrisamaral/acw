/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        StdListItem,
        ContactItem,
        AlertList;

    components.ContactItem = React.createClass({
        render: function(){
            return (<li className='list-group-item'><span>{this.props.item}</span></li>)
        }
    });
    ContactItem = components.ContactItem;
    components.ContactList = React.createClass({
        render: function () {
            return (<ul className='list-group ContactList'>
                {
                    this.props.list.map(function(item){
                        return (<ContactItem item={item} key={item} />);
                    }.bind(this))
                    }
            </ul>);
        }
    });

    components.UserAvatar = React.createClass({
        render: function () {
            return (<img className='userAvatarThumb' src={this.props.src ? this.props.src : '/img/user-large.png'} />);
        }
    });

    components.ProgressBar = React.createClass({
        render: function () {
            var progStyle = {width: this.props.progress + '%'};
            return (<div className='progress'>
                <div className="progress-bar"
                role="progressbar" aria-valuenow={this.props.progress}
                aria-valuemin="0" aria-valuemax="100" style={progStyle}>
                                {this.props.progress + '%'}
                </div>
            </div>);
        }
    });

    components.AlertList = React.createClass({
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
                <div className='formAlerts'>
                    {_.map(this.props.alerts, function (alert, key) {
                        var classes = {alert: true};
                        classes['alert-' + alert[0]] = true;
                        return (
                            <div key={key} className={React.addons.classSet(classes)}>
                                <button data-alert-id={key} onClick={this.dismissAlert} type="button" className="close" aria-hidden="true">&times;</button>
                                    {alert[1]}
                            </div>);
                    }.bind(this))}
                </div>);
        }
    });
    AlertList = components.AlertList;

    components.StdForm = React.createClass({
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
            return <form action={this.props.action + (notNew ? '/' + this.props.item.id : '')} role='form' onSubmit={this.handleSubmit}>
                <div className='row'>
                    <div className='col-md-4 form-group'>
                        <label htmlFor='itemAbbr'>Nome</label>
                        <input id='itemAbbr' name='abbr' maxLength={15} className='form-control' type='text' required={true} valueLink={this.linkState('abbr')} />
                    </div>
                    <div className='col-md-8 form-group'>
                        <label htmlFor='itemName'>Descrição/Slogan/Motto</label>
                        <textarea id='itemName' name='name' rows={3} className='form-control' maxLength={200} type='text' required={true} valueLink={this.linkState('name')} />
                    </div>
                </div>
                <AlertList alerts={this.state.alerts} dismissAlert={this.dismissAlert} />
                <div className='row'>
                    <div className='col-md-4'>
                        <div className='checkbox'>
                            <label>
                                <input name='active' type='checkbox'
                                    onChange={this.onCheck}
                                    checked={this.state.active}
                                    value='on' />{'Ativar ' + this.props.iname}
                            </label>
                        </div>
                    </div>
                    <div className='col-md-8'>
                        <button className='btn btn-default' type='submit'>Salvar</button>
                    </div>
                </div>
            </form>;
        }
    });

    components.StdListItem = React.createClass({
        clickItem: function (e) {
            e.preventDefault();

            if (this.props.setSelected) {
                this.props.setSelected(this.props.item);
            } else if (this.props.onClick) {
                this.props.onClick(this.props.item);
            }

        },
        render: function () {
            return <a href='#'
                className={React.addons.classSet({
                    'list-group-item': true,
                    stdListItem: true,
                    active: this.props.selected,
                    'deleted-item': !this.props.item.active
                })} onClick={this.clickItem}>
                    <h5 className='list-group-item-heading'>{this.props.item.abbr}</h5>
                    <p className='list-group-item-text'>{this.props.item.name}</p>
            </a>;
        }
    });
    StdListItem = components.StdListItem;

    components.StdList = React.createClass({
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
            return (<div className='stdList list-group'>
                {
                    this.state.items
                        .map(function (item) {
                            return (<StdListItem
                                        key={item.id}
                                        item={item}
                                        selected={item.id === selected.id}
                                        setSelected={this.props.setSelected} />);
                        }.bind(this))
                    }
            </div>);
        }
    });
}(window, jQuery));