###
Model: Represents a specifications 'describe' block.
###
module.exports = (module) ->
  class Describe extends module.mvc.Model
    defaults:
        title:    null
        summary:  null
        func:     null
    
    ###
    Constructor
    @param params: The array of arguments retreived from the describe function.
    ###
    constructor: (params) -> 
        
        # Setup initial conditions.
        super
        params = [params] unless _(params).isArray()
        last = _(params).last()
        @descriptions = new Describe.Collection()
        
        # Store parts.
        @title params[0]
        @summary params[1] if _(params[1]).isString()
        @func last if _(last).isFunction()
    
    
    ###
    Invokes the 'describe' function to get child specs and descriptions.
    ###
    init: -> 
        # Setup initial conditions.
        return if @isInitialized is yes
        @isInitialized = yes
        return unless @func()?
        
        # Invoke the function to get the children.
        resetDescriptions()
        @func()()
        for d in HARNESS.descriptions
            @descriptions.add new module.models.Describe d
        resetDescriptions()
        
        
        
    
  # PRIVATE --------------------------------------------------------------------------
  
  resetDescriptions = -> HARNESS.descriptions = []
  
  
  
  # Collection.
  class Describe.Collection extends module.mvc.Collection
    model: Describe
    comparator: (model) -> model.title()
  
  
  
  # Export.
  Describe
  
  
  
  
  


  