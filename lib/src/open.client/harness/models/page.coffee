
###
A simple page model that is accessed from within specs.
Events:
 - add
 - clear
 - reset

###
module.exports = (module) ->
  class Page 
    constructor: -> 
        _.extend @, Backbone.Events
        
    ###
    Adds a new element to the Test Harness
    @param el : The element to test.
    @param options: 
              - width:  A value for the width of the element being added.  
                        If a string is supplied the value should contain units (eg. '80%')
                        If a number is supplied pixels are used (eg. 200 => '200px')
              - height: A value for the width of the element being added.  
                        If a string is supplied the value should contain units (eg. '80%')
                        If a number is supplied pixels are used (eg. 200 => '200px')
    ###
    add: (el, options = {}) -> 
        el = module.util.toJQuery(el)
        @trigger 'add', element: el, options: options
    
    
    # Clears the currently hosted test element.
    clear: -> @trigger 'clear'

    # Complete reset of the Test Harness.
    reset: -> @trigger 'reset'
    
  