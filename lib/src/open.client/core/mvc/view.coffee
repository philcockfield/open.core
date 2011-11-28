common = require './_common'
Model  = require './model'
util   = common.util


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
  constructor: (params = {}) -> View::_construct.call @, params
  
  
  ###
  Called internally by the constructor.  
  Use this if properties are added to the object after 
  construction and you need to re-run the constructor,
  (eg. within a functional inheritance pattern).
  ###
  _construct: (params = {}) -> 
      
      # Setup initial conditions.
      View.__super__.constructor.call @, params
      
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
  Deterines whether the view element currently has focus.
  @returns true if the element is focused, otherwise false.
  ###
  hasFocus: -> 
    
    # Note: Checking against the [activeElement] is faster than doing
    #       an [ @el.is(':focus') ] because it avoids a complete query of the DOM tree.
    $(document.activeElement).get(0) is @el.get(0)
  
  
  ###
  Replaces the given element with the view.
  @param el: The element to replace, this can be a:
              - CSS selector (string)
              - DOM element
              - jQuery object
              - MVC View
  
  This method:
    - copies all CSS classes from the replaced element.
    - sets default property values specified in data-{propName} attributes.
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
          # Don't override the View element's existing ID.
          viewId = self.el.attr('id')
          return if viewId? and viewId isnt ''
          
          # Retrieve the ID from the element being replaced.
          id = el.attr('id')
          return unless id?
          return if _(id).isBlank()
          
          # Assign the ID to the view and the el.
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
  Appends the given element with the view.
  @param el: The element to replace, this can be a:
              - CSS selector (string)
              - DOM element
              - jQuery object
              - MVC View
  ###
  append: (el) -> 
      el = util.toJQuery(el)
      el.append(@.el) if el?
      @
  
  ###
  Renders a string version of the element's HTML.
  ###
  outerHtml: -> View.outerHtml @el
  
  
  # PRIVATE INSTANCE --------------------------------------------------------------------------
  
  
  # The text that all CSS styles are prefixed with.
  # This can be changed when overriding the button in different libraries.
  # Do not include trailing underscore (_).
  _cssPrefix: 'core'
  
  ###
  Produces a CSS class name by appending the given name on the controls CSS prefix.
  @param name: The CSS class name to append.
  @returns the CSS class name in the form "{prefix}_{name}".
  ###
  _className: (name) -> "#{@_cssPrefix}_#{name}"
  
  

# PRIVATE STATIC --------------------------------------------------------------------------


###
Renders a string version of the element's HTML.
@param el: The element to render (either a jQuery or HTML DOM element).
@returns the string.
###
View.outerHtml = (el) -> 
  return null unless el?
  return el if _(el).isString()
  el = util.toJQuery el
  outer = $ '<div></div>'
  outer.append el.clone(false)
  outer.html()


syncClasses = (view) -> 
    toggle = (className, apply) -> view.el.toggleClass view._className(className), apply
    isEnabled = view.enabled()
    toggle 'enabled', isEnabled
    toggle 'disabled', not isEnabled

syncVisibility = (view, visible) -> 
      display = if visible then '' else 'none'
      view.el.css 'display', display
