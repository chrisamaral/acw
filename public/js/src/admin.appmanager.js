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

    AppIconForm = React.createClass({displayName: 'AppIconForm',
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
                this.refs.appIconPreview.getDOMNode().value = '';
                return this.setState({preview: null});
            }

            if (!fPattern.test(imgFile.type)) {
                new_alerts[acw.uniqueId()] = ['danger', (React.DOM.div(null, React.DOM.strong(null, "Formato inválido!"), " Os formatos válidos são ", React.DOM.strong(null, "jpeg"), " e ", React.DOM.strong(null, "png")))];
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
                    new_alerts[acw.uniqueId()] = ['danger', (React.DOM.div(null, React.DOM.strong(null, this.responseText), " Não foi possível salvar o novo ícone"))];
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

            return (React.DOM.form( {onSubmit:this.handleSubmit, role:"form", action:'/admin/app/' + this.props.id + '/icon', encType:"multipart/form-data"}, 
                React.DOM.input( {name:"id", type:"hidden", value:this.props.id} ),
                React.DOM.div( {className:"iconPreview"}, 
                    React.DOM.span( {className:"helper"}),
                    React.DOM.img( {className:"originalIcon", src:this.props.icon ? this.props.icon : '/img/none.png'}),
                    React.DOM.span( {className:"glyphicon glyphicon-hand-right"}),
                    React.DOM.img( {className:"previewIcon", src:this.state.preview ? this.state.preview : '/img/none.png'})
                ),
                AlertList( {alerts:this.state.alerts, dismissAlert:this.dismissAlert} ),
                React.DOM.div( {className:"input-group"}, 
                    React.DOM.input( {ref:"appIconPreview",
                        name:"icon",
                        onChange:this.loadPreview,
                        type:"file", required:true,
                        className:"form-control"} ),
                    React.DOM.div( {className:"input-group-btn"}, 
                        React.DOM.button( {className:"btn btn-danger", onClick:this.removePreview}, "Cancelar"),
                        React.DOM.button( {className:"btn btn-success", type:"submit"}, "Salvar")
                    )
                ),
                this.state.uploadProgress
                    ? ProgressBar( {progress:this.state.uploadProgress} )
                    : null
                
            ));
        }
    });

    components.AppManager =  React.createClass({displayName: 'AppManager',
        getInitialState: function () {
            return {
                selected: new App(),
                forceUpdate: (new Date()).getTime()
            };
        },
        setSelected: function (item, forceReload) {
            var new_state = {
                selected: !forceReload && item.id === this.state.selected.id
                    ? new App()
                    : item
            };

            if (forceReload) {
                new_state.forceUpdate = (new Date()).getTime();
            }

            this.setState(new_state);
        },
        setIcon: function (icon) {
            this.setState({selected: _.merge(this.state.selected, {icon: icon})});
        },
        render: function () {
            return (
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        AppList(
                            {uri:"/admin/apps",
                            forceUpdate:this.state.forceUpdate,
                            selected:this.state.selected,
                            setSelected:this.setSelected} )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        AppForm(
                            {action:"/admin/app",
                            item:this.state.selected,
                            iname:'aplicativo',
                            setSelected:this.setSelected} ),
                        this.state.selected.id
                            ? AppIconForm(
                                    {setIcon:this.setIcon,
                                    id:this.state.selected.id,
                                    icon:this.state.selected.icon} )
                            : null
                        
                    )
                )
            );
        } 
    });
}(window, jQuery));