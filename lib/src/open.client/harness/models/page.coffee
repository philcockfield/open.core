
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
    ###
    add: (el) -> 
        el = module.core.util.toJQuery(el)
        @trigger 'add', element: el
    
    
    # Clears the Test Harness.
    clear: -> @trigger 'clear'

    # Complete reset of the Test Harness.
    reset: -> @trigger 'reset'
    
  