###
A simple page model that is accessed from within specs.

Events:
   - add
   - add:css
   - clear
   - reset

###
module.exports = (module) ->
  class Page
    constructor: -> 
        _.extend @, Backbone.Events
    
    
    # Gets the [ContextPane] - the panel to display options below the control host.
    pane: undefined # Set by Main.
    
    
    ###
    Adds a new element to the Test Harness
    @param el : The element to test.
    @param options: 
              - width:     A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80%')
                           If a number is supplied pixels are used (eg. 200 => '200px')
                           If '*' is supplied it is converted to '100%'.
              - height:    A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80%')
                           If a number is supplied pixels are used (eg. 200 => '200px')
                           If '*' is supplied it is converted to '100%'.
              - showTitle: Flag indicating if the title, and description, should be displayed (default true).
              - fill:      Flag indicating if width/height values should be set to '100%' (default false).
              - scroll:    Scroll behavior for container. 'x', 'y', 'xy', null.  Default:null
              - border:    A color (string) or a bolean (yes/no) for whether a border should be put around the hosted control.
              - reset:     Flag indicating if the 'Reset' method should be invoked before adding.
    ###
    add: (el, options = {}) -> 
        @reset() if options.reset is yes
        @trigger 'add', element: module.util.toJQuery(el), options: options
        el
    
    
    ###
    Adds a stylesheet link to the page.
    @param urls: Array of URL's to the stylehseet(s) to add.
    ###
    css: (urls...) -> @trigger 'css', urls:urls
    
    
    # Clears the currently hosted test element.
    clear: -> @trigger 'clear'
    
    
    # Complete reset of the Test Harness.
    reset: -> @trigger 'reset'
    
    
  