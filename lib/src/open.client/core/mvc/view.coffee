common = require 'open.client/core/mvc/_common'
Model = common.using 'model'


syncVisibility = (view, visible) -> 
      display = if visible then '' else 'none'
      view.el.css 'display', display


###
Base class for visual controls.
###
module.exports = class View extends Model
  ###
  Constructor.
  @param params
          - tagName   : (optional). The tag name for the View's root element (default: DIV)
          - className : (optional). The CSS class name for the root element.
          - el        : (optional). An explicit element to use.
          
  ###
  constructor: (params = {}) ->
      # Setup initial conditions.
      super
      
      # Property functions.
      @addProps
          enabled: true
          visible: true

      # Create the wrapped Backbone View.
      view = new Backbone.View
                    tagName:   params.tagName
                    className: params.className
                    el:        params.el
      
      # Store internal state.
      @_ =
          view: view
          atts: params
      @element = view.el
      @el = $(@element)

      # Wire up events.
      @visible.onChanged (e) => syncVisibility(@, e.newValue)
      
      # Assign public methods.
      @$    = view.$
      @make = view.make



  ###
  Renders the given HTML within the view.
  ###
  html: (html) ->
      el = @el
      if html?
        el.html html
      el.html()

