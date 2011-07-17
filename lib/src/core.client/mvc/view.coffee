Base = require '../base'

###
Base class for visual controls.
###
module.exports = class View extends Base
  constructor: (params = {}) ->
      # Setup initial conditions.
      super

      # Create the wrapped Backbone View.
      view = new Backbone.View
                    tagName: params.tagName
                    className: params.className

      # Store internal state.
      @_ =
        view: view
        atts: params
      @el = $(view.el)

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


  ###
  Gets or sets whether the view is visible.
  ###
  visible: (isVisible) ->
      if isVisible?
          @el.css 'display', if isVisible then '' else 'none'
      @el.css('display') != 'none'


