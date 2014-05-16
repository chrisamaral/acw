/** @jsx React.DOM */
(function (window, $) {
    "use strict";

    var acw = window.acw,
        components = acw.components,
        React = window.React,
        AppList = components.StdList,
        AppItem = components.StdListItem,
        AppForm = components.StdForm,
        AppIconForm,
        ProgressBar = components.ProgressBar,
        AlertList = components.AlertList;

    function App() {
        this.id = null;
        this.abbr = '';
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
                new_alerts[acw.uniqueId()] = ['danger', (<div><strong>Formato inválido!</strong> Os formatos válidos são <strong>jpeg</strong> e <strong>png</strong></div>)];
                this.refs.appIconPreview.getDOMNode().value = '';
                return this.setState({preview: null, alerts: new_alerts});
            }

            fReader.onload = function (e) {
                this.setState({preview: e.target.result});
            }.bind(this);
            fReader.readAsDataURL(imgFile);
        },
        dismissAlert: function (id) {
            var new_alerts = this.state.alerts;
            delete new_alerts[id];
            this.setState({alerts: new_alerts});
        },
        handleSubmit: function (e) {
            e.preventDefault();
            var form = new FormData(e.currentTarget), xhr = new XMLHttpRequest(), that = this;
            xhr.open('POST', e.currentTarget.action, true);
            xhr.onload = function (e) {
                var new_alerts = that.state.alerts;
                if (this.status === 200) {
                    that.props.setIcon(this.responseText);
                    that.setState({preview: null});
                } else {
                    new_alerts[acw.uniqueId()] = ['danger', (<div><strong>{this.responseText}</strong> Não foi possível salvar o novo ícone</div>)];
                    that.setState({alerts: new_alerts, preview: null});
                }
                setTimeout(function(){
                    that.setState({uploadProgress: 0});
                }, 1000);
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

            return (<form onSubmit={this.handleSubmit} role='form' action={'/admin/app/' + this.props.id + '/icon'} encType='multipart/form-data'>
                <input name='id' type='hidden' value={this.props.id} />
                <div className='iconPreview'>
                    <span className='helper'></span>
                    <img className='originalIcon' src={this.props.icon ? this.props.icon : '/img/none.png'}/>
                    <span className='glyphicon glyphicon-hand-right'></span>
                    <img className='previewIcon' src={this.state.preview ? this.state.preview : '/img/none.png'}/>
                </div>
                <AlertList alerts={this.state.alerts} dismissAlert={this.dismissAlert} />
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
                {this.state.uploadProgress
                    ? <ProgressBar progress={this.state.uploadProgress} />
                    : null
                }
            </form>);
        }
    });

    components.AppManager =  React.createClass({
        getInitialState: function () {
            return {selected: new App()};
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
                        <AppList
                            uri='/admin/apps'
                            selected={this.state.selected}
                            setSelected={this.setSelected} />
                    </div>
                    <div className='col-md-8'>
                        <AppForm
                            action='/admin/app'
                            item={this.state.selected}
                            iname={'aplicativo'}
                            setSelected={this.setSelected} />
                        {this.state.selected.id
                            ? <AppIconForm
                                    setIcon={this.setIcon}
                                    id={this.state.selected.id}
                                    icon={this.state.selected.icon} />
                            : null
                        }
                    </div>
                </div>
            );
        } 
    });
}(window, jQuery));