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
    constructor: -> _.extend @, Backbone.Events
    
    
    ###
    Adds a new element to the Test Harness
    @param el : The element to test.
    @param options: 
              - width:     A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80%')
                           If a number is supplied pixels are used (eg. 200 => '200px')
              - height:    A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80%')
                           If a number is supplied pixels are used (eg. 200 => '200px')
              - showTitle: Flag indicating if the title, and description, should be displayed (default true).
              - fill:      Flag indicating if width/height values should be set to '100%' (default false).
              - border:    A color (string) or a bolean (yes/no) for whether a border should be put around the hosted control.
    ###
    add: (el, options = {}) -> 
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
    
    
  