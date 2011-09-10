common = require 'open.client/core/mvc/_common'
util   = common.util
Model  = common.using 'model'


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
      @visible.onChanged (e) => syncVisibility @, e.newValue
      @enabled.onChanged (e) => syncClasses @
      
      # Assign public methods.
      @$    = view.$
      @make = view.make
      
      # Finish up.
      syncClasses @


  ###
  Renders the given HTML within the view.
  ###
  html: (html) ->
      el = @el
      if html?
        el.html html
      el.html()


  ###
  Replaces the given element with the view.
  @param el: The element to replace, this can be a:
              - CSS selector (string)
              - DOM element
              - jQuery object
              - MVC View

  This method:
    - copies all CSS classes from the replaced element.
    - sets default property values specified in the [data-defaults] attribute
      of the replaced element, eg:
          
          data-defaults=" enabled:false, foo:'bar' "

  ###
  replace: (el) -> 
      
      # Setup initial conditions.
      self = @
      el   = util.toJQuery(el)
      return @ unless el?
      
      # Copy CSS classes from source element.
      classes = el.attr('class')?.split(/\s+/)
      self.el.addClass(name) for name in classes if classes?

      # Copy ID from source element.
      do -> 
          return if self.el.attr('id')? # Don't override the View element's existing ID.
          id = el.attr('id')
          return unless id?
          return  if _(id).isBlank()
          self.el.attr 'id', id
          self.id = id unless self.id?
      
      # Set default values - copy [data-*] values from source element.
      do -> 
          # Retrieve the data attributes.
          atts = (d for d of el.data())
          return unless atts.length > 0
        
          # Write each value to the view (if it has a corresponding prop-function).
          for name in atts
              prop = self[name]
              prop(el.data(name)) if (prop instanceof Function)
        
      # Replace the element with the View's element.
      el.replaceWith @el
      
      # Finish up.
      @



###
PRIVATE
###
syncClasses = (view) -> 
    view.el.toggleClass 'core_disabled', not view.enabled()

syncVisibility = (view, visible) -> 
      display = if visible then '' else 'none'
      view.el.css 'display', display
