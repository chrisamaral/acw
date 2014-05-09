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
        AppIconForm,
        ProgressBar,
        AlertList;

    function App() {
        this.id = null;
        this.abbr = '';
        this.name = '';
        this.active = false;
        this.icon = null;
    }
    ProgressBar = React.createClass({displayName: 'ProgressBar',
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
    components.ProgressBar = ProgressBar;

    AlertList = React.createClass({displayName: 'AlertList',
        render: function() {
            return (
                React.DOM.div( {className:"formAlerts"}, 
                    _.map(this.props.alerts, function (alert, key) {
                        var classes = {alert: true};
                        classes['alert-' + alert[0]] = true;
                        return (
                            React.DOM.div( {key:key, className:React.addons.classSet(classes)}, 
                                React.DOM.button( {'data-alert-id':key, onClick:this.props.dismissAlert, type:"button", className:"close", 'aria-hidden':"true"}, "×"),
                                    alert[1]
                            ));
                    }.bind(this))
                ));
        }
    });
    components.AlertList = AlertList;

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
                return this.setState({preview: null});
                this.refs.appIconPreview.getDOMNode().value = '';
            }

            if (!fPattern.test(imgFile.type)) {
                new_alerts[uniqueId()] = ['danger', (React.DOM.div(null, React.DOM.strong(null, "Formato inválido!"), " Os formatos válidos são ", React.DOM.strong(null, "jpeg"), " e ", React.DOM.strong(null, "png")))];
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
                    that.setState({preview: null});
                } else {
                    new_alerts[uniqueId()] = ['danger', (React.DOM.div(null, React.DOM.strong(null, this.responseText), " Não foi possível salvar o novo ícone"))];
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
    AppForm = React.createClass({displayName: 'AppForm',
        mixins: [React.addons.LinkedStateMixin],
        getInitialState: function () {
            return {
                id: this.props.id,
                abbr: this.props.abbr,
                name: this.props.name,
                active: this.props.active,
                alerts: {}
            };
        },
        dismissAlert: function (e) {
            e.preventDefault();
            var new_alerts = this.state.alerts;
            delete new_alerts[$(e.currentTarget).data('alert-id')];
            this.setState({alerts: new_alerts});
            return false;
        },
        onCheck: function(e){
            var input = e.currentTarget;
            this.setState({active: input.checked});
        },
        handleSubmit: function (e) {
            e.preventDefault();
            $.post(e.currentTarget.action, $(e.currentTarget).serialize())
                .done(function(id){
                    this.props.setSelected({
                        id: id,
                        abbr: this.state.abbr,
                        name: this.state.name,
                        active: this.state.active
                    }, true);
                }.bind(this))
                .fail(function(xhr){
                    var new_alerts = this.state.alerts;
                    new_alerts[uniqueId()] = ['danger', xhr.responseText];
                    this.setState({
                        alerts: new_alerts
                    });
                }.bind(this));
        },
        componentWillReceiveProps: function(props){
            this.setState(_.merge(this.state, props));
        },
        render: function () {
            var notNew = this.props.id !== null;
            return (React.DOM.form( {action:this.props.action + (notNew ? '/' + this.props.id : ''),
                        role:"form", onSubmit:this.handleSubmit}, 
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4 form-group"}, 
                        React.DOM.label( {htmlFor:"itemAbbr"}, "Abreviação"),
                        React.DOM.input( {id:"itemAbbr", name:"abbr", maxLength:15, className:"form-control", type:"text", required:true, valueLink:this.linkState('abbr')} )
                    ),
                    React.DOM.div( {className:"col-md-8 form-group"}, 
                        React.DOM.label( {htmlFor:"itemName"}, "Nome"),
                        React.DOM.input( {id:"itemName", name:"name", className:"form-control", type:"text", required:true, valueLink:this.linkState('name')} )
                    )
                ),
                AlertList( {alerts:this.state.alerts, dismissAlert:this.dismissAlert} ),
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        React.DOM.div( {className:"checkbox"}, 
                            React.DOM.label(null, 
                                React.DOM.input( {name:"active", type:"checkbox", onChange:this.onCheck,
                                        checked:this.state.active,
                                        value:"on"} ), " Ativar aplicativo"
                            )
                        )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        React.DOM.button( {className:"btn btn-default", type:"submit"}, "Salvar")
                    )
                )
            ));
        }
    });
    components.StdForm = AppForm;

    AppItem = React.createClass({displayName: 'AppItem',
        clickItem: function (e) {
            e.preventDefault();
            this.props.setSelected(this.props.item);
        },
        render: function () {
            return (
                React.DOM.a( {href:"#",
                    className:
                        React.addons.classSet({
                            'list-group-item': true,
                            stdListItem: true,
                            deleted: !this.props.item.active
                        }),
                    onClick:this.clickItem}, 
                this.props.selected ? '❯ ' + this.props.item.name : this.props.item.name)
            );
        }
    });
    components.StdListItem;

    AppList = React.createClass({displayName: 'AppList',
        getInitialState: function(){
            return {items: []};
        },
        reloadList: function(){
            $.get(this.props.uri)
                .done(function(items){
                    this.setState({items: items});
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
                theOne = this.state.items.filter(function(item){
                    return item.id === selected.id;
                })[0];
            return (React.DOM.div( {className:"stdList list-group"}, 
                theOne ?
                    (React.DOM.div( {className:"selected"}, 
                        AppItem(
                            {key:theOne.id,
                            item:theOne,
                            selected:true,
                            setSelected:this.props.setSelected} )
                    ))
                    : null,
                React.DOM.div( {className:"others", onScroll:this.scrollChange}, 
                    
                        this.state.items
                            .filter(function (item) {
                                return item.id !== selected.id;
                            })
                            .map(function (item) {
                                return (AppItem(
                                            {key:item.id,
                                            item:item,
                                            setSelected:this.props.setSelected} ));
                            }.bind(this))
                    
                )
            ));
        }
    });
    components.StdList = AppList;

    components.AppManager =  React.createClass({displayName: 'AppManager',
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
                React.DOM.div( {className:"row"}, 
                    React.DOM.div( {className:"col-md-4"}, 
                        AppList(
                            {uri:"/admin/apps",
                            selected:this.state.selected,
                            setSelected:this.setSelected} )
                    ),
                    React.DOM.div( {className:"col-md-8"}, 
                        AppForm(
                            {action:"/admin/app",
                            id:this.state.selected.id,
                            abbr:this.state.selected.abbr,
                            name:this.state.selected.name,
                            active:this.state.selected.active,
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