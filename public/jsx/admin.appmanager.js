/** @jsx React.DOM */
(function (window, $) {
    "use strict";
    function uniqueId(){
        return String.fromCharCode(65 + Math.floor(Math.random() * 26)).toLowerCase() + Date.now().toString(36);
    }
    var acw = window.acw,
        components = acw.components,
        React = window.React,
        AppList,
        AppItem,
        AppForm,
        AppIconForm;

    function App() {
        this.id = '';
        this.name = '';
        this.active = false;
        this.icon = null;
    }
    AppIconForm = React.createClass({
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function(){
            return {preview: null, alerts: {}, uploadProgress: 0};
        },
        removePreview: function(e){
            e.preventDefault();
            this.setState({preview: null});
            this.refs.appIconPreview.getDOMNode().value = '';
        },
        loadPreview: function (e) {

            var fInput = e.currentTarget,
                fReader = new FileReader(),
                imgFile = fInput.files[0],
                fPattern = /^(image\/jpeg|image\/png)$/i,
                new_alerts = this.state.alerts;

            if (!imgFile) {
                return this.setState({preview: null});
                this.refs.appIconPreview.getDOMNode().value = '';
            }

            if (!fPattern.test(imgFile.type)) {
                new_alerts[uniqueId()] = ['danger', (<div><strong>Formato inválido!</strong> Os formatos válidos são <strong>jpeg</strong> e <strong>png</strong></div>)];
                this.refs.appIconPreview.getDOMNode().value = '';
                return this.setState({preview: null, alerts: new_alerts});
            }

            fReader.onload = function (e) {
                this.setState({preview: e.target.result});
            }.bind(this);
            fReader.readAsDataURL(imgFile);
        },
        dismissAlert: function (e) {
            e.preventDefault();
            var new_alerts = this.state.alerts;
            delete new_alerts[$(e.currentTarget).data('alert-id')];
            this.setState({alerts: new_alerts});
            return false;
        },
        handleSubmit: function (e) {
            e.preventDefault();
            var form = new FormData(e.currentTarget), xhr = new XMLHttpRequest(), that = this;
            xhr.open('POST', e.currentTarget.action, true);
            xhr.onload = function (e) {
                var new_alerts = that.state.alerts;
                if (this.status === 200) {
                    that.props.setIcon(this.responseText);
                    that.setState({preview: null, uploadProgress: 0});
                } else {
                    new_alerts[uniqueId()] = ['danger', (<div><strong>{this.responseText}</strong> Não foi possível salvar o novo ícone</div>)];
                    that.setState({alerts: new_alerts, preview: null, uploadProgress: 0});
                }
                that.refs.appIconPreview.getDOMNode().value = '';
            };
            xhr.upload.onprogress = function (e) {
                if (e.lengthComputable) {
                    that.setState({uploadProgress: (e.loaded / e.total) * 100});
                }
            };
            xhr.send(form);
        },
        render: function () {
            var progStyle = {width: this.state.uploadProgress + '%'};
            return (<form onSubmit={this.handleSubmit} role='form' action={'/admin/app/' + this.props.id + '/icon'} encType='multipart/form-data'>
                <input name='id' type='hidden' value={this.props.id} />
                <div className='input-group'>
                    <input ref='appIconPreview'
                        name='icon'
                        onChange={this.loadPreview}
                        type='file' required={true}
                        className='form-control' />
                    <div className='input-group-btn'>
                        <button className='btn btn-danger' onClick={this.removePreview}>Cancelar</button>
                        <button className='btn btn-success' type='submit'>Salvar</button>
                    </div>
                </div>
                <div className='formAlerts'>
                    {_.map(this.state.alerts, function(alert, key){
                        var classes = {alert: true};
                        classes['alert-' + alert[0]] = true;
                        return (<div key={key} className={React.addons.classSet(classes)}>
                                <button data-alert-id={key} onClick={this.dismissAlert} type="button" className="close" aria-hidden="true">&times;</button>
                                {alert[1]}
                            </div>
                        );
                    }.bind(this))}
                </div>

                {this.state.uploadProgress
                    ? (<div className='progress'>
                        <div className="progress-bar"
                                role="progressbar" aria-valuenow={this.state.uploadProgress}
                                aria-valuemin="0" aria-valuemax="100"
                                style={progStyle}>
                            {this.state.uploadProgress + '%'}
                        </div>
                    </div>) : ''
                }
                <div className='iconPreview'>
                    <span className='helper'></span>
                    <img className='originalIcon' src={this.props.icon ? this.props.icon : '/img/none.png'}/>
                    <span className='glyphicon glyphicon-hand-right'></span>
                    <img className='previewIcon' src={this.state.preview ? this.state.preview : '/img/none.png'}/>
                </div>
            </form>);
        }
    });
    AppForm = React.createClass({
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function () {
            return {id: this.props.id, name: this.props.name, active: this.props.active};
        },
        onCheck: function(e){
            var input = e.currentTarget;
            this.setState({active: input.checked});
        },
        handleSubmit: function (e) {
            e.preventDefault();
            $.post(e.currentTarget.action, $(e.currentTarget).serialize())
                .done(function(){
                    this.props.setSelected({
                        id: this.state.id,
                        name: this.state.name,
                        active: this.state.active
                    }, true);
                }.bind(this));
        },
        componentWillReceiveProps: function(props){
            this.setState(_.merge(this.state, props));
        },
        render: function () {
            var notNew = this.props.id && this.props.id.length;
            return (<form action={'/admin/app' + (notNew ? '/' + this.props.id : '')}
                        role='form' onSubmit={this.handleSubmit}>
                <div className='row'>
                    <div className='col-md-4 form-group'>
                        <label htmlFor='appId'>Abreviação</label>
                        <input id='appId' name='id' className='form-control' type='text' required={true} readOnly={notNew} valueLink={this.linkState('id')} />
                    </div>
                    <div className='col-md-8 form-group'>
                        <label htmlFor='appName'>Nome</label>
                        <input id='appName' name='name' className='form-control' type='text' required={true} valueLink={this.linkState('name')} />
                    </div>
                </div>
                <div className='row'>
                    <div className='col-md-4'>
                        <div className='checkbox'>
                            <label>
                                <input name='active' type='checkbox' onChange={this.onCheck}
                                        checked={this.state.active}
                                        value='on' /> Ativar aplicativo
                            </label>
                        </div>
                    </div>
                    <div className='col-md-8'>
                        <button className='btn btn-default' type='submit'>Salvar</button>
                    </div>
                </div>
            </form>);
        }
    });

    AppItem = React.createClass({
        clickApp: function (e) {
            e.preventDefault();
            this.props.setSelected(this.props.item);
        },
        render: function () {
            return (
                <a href='#'
                    className=
                        {React.addons.classSet({
                            'list-group-item': true,
                            stdListItem: true,
                            deleted: !this.props.item.active
                        })}
                    onClick={this.clickApp}>
                {this.props.selected ? '❯ ' + this.props.item.name : this.props.item.name}</a>
            );
        }
    });

    AppList = React.createClass({
        getInitialState: function(){
            return {apps: []};
        },
        reloadList: function(){
            $.get('/admin/apps')
                .done(function(apps){
                    this.setState({apps: apps});
                }.bind(this));
        },
        componentDidMount: function(){
            this.reloadList();
        },
        componentWillReceiveProps: function(){
            this.reloadList();
        },
        render: function(){
            var selected = this.props.selected,
                theOne = this.state.apps.filter(function(item){
                    return item.id === selected.id;
                })[0];
            return (<div className='stdList list-group'>
                {theOne ?
                    (<div className='selected'>
                        <AppItem
                            key={theOne.id}
                            item={theOne}
                            selected={true}
                            setSelected={this.props.setSelected} />
                    </div>)
                    : ''}
                <div className='others' ref='userList' onScroll={this.scrollChange}>
                    {
                        this.state.apps
                            .filter(function (item) {
                                return item.id !== selected.id;
                            })
                            .map(function (item) {
                                return (<AppItem
                                            key={item.id}
                                            item={item}
                                            setSelected={this.props.setSelected} />);
                            }.bind(this))
                    }
                </div>
            </div>);
        }
    });
    components.AppManager =  React.createClass({
        getInitialState: function () {
            return ({selected: new App()});
        },
        setSelected: function (item, keepOn) {
            this.setState({
                selected: !keepOn && item.id === this.state.selected.id
                    ? new App()
                    : item
            });
        },
        setIcon: function (icon) {
            this.setState({selected: _.merge(this.state.selected, {icon: icon})});
        },
        render: function () {
            return (
                <div className='row'>
                    <div className='col-md-4'>
                        <AppList selected={this.state.selected} setSelected={this.setSelected} />
                    </div>
                    <div className='col-md-8'>
                        <AppForm
                            id={this.state.selected.id}
                            name={this.state.selected.name}
                            active={this.state.selected.active}
                            setSelected={this.setSelected} />
                        {this.state.selected.id && this.state.selected.id.length
                            ? <AppIconForm
                                    setIcon={this.setIcon}
                                    id={this.state.selected.id}
                                    icon={this.state.selected.icon} />
                            : ''
                        }
                    </div>
                </div>
            );
        } 
    });
}(window, jQuery));