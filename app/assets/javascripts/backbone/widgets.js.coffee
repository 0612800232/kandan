class Kandan.Widgets
  @widgets: {}

  @register: (widget_name, callback)->
    @widgets[widget_name] = callback

  @all: ()->
    @widgets

  @widget_names: ()->
    widget_names = []
    for widget_name of @all()
      widget_names.push(widget_name) if @all().hasOwnProperty(widget_name)
    widget_names

  @init_all: ()->
    @init(widget_name) for widget_name in @widget_names()

  @init: (widget_name)->
    # TODO use the widget_name property on the plugin module to get the title
    $(".sidebar").append("<h3>#{widget_name}</h3><div class='#{widget_name}'></div>")
    @render(widget_name)

  @render: (widget_name)->
    $widget_el = $(".sidebar .#{widget_name}")
    eval(@widgets[widget_name]).render($widget_el) if $widget_el != []
