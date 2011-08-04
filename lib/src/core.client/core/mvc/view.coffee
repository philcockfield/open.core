Base = require '../base'

syncVisibility = (view, visible) -> 
      display = if visible then '' else 'none'
      view.el.css 'display', display


###
Base class for visual controls.
###
module.exports = class View extends Base
  constructor: (params = {}) ->
      # Setup initial conditions.
      super
      _.extend @, Backbone.Events
      
      # Property functions.
      @addProps
          enabled: true
          visible: true

      # Create the wrapped Backbone View.
      view = new Backbone.View
                    tagName:   params.tagName
                    className: params.className
      
      # Store internal state.
      @_ =
          view: view
          atts: params
      @el = $(view.el)

      # Wire up events.
      @visible.onChanged (e) => syncVisibility(@, e.newValue)
      
      # Assign public methods.
      @$ = view.$



  ###
  Renders the given HTML within the view.
  ###
  html: (html) ->
      el = @el
      if html?
        el.html html
      el.html()

