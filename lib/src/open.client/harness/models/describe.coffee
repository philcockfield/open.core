###
Model: Represents a specifications 'describe' block.
###
module.exports = (module) ->
  It = module.model 'it'
  
  class Describe extends module.mvc.Model
    defaults:
        title:    null
        summary:  null
        func:     null
    
    ###
    Constructor.
    @param params: The array of arguments retreived from the describe function.
    ###
    constructor: (params) -> 
        
        # Setup initial conditions.
        super
        params = [params] unless _(params).isArray()
        last = _(params).last()
        
        # Collections.
        @descriptions = new Describe.Collection()
        @its          = new It.Collection()
        
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
        
        # Invoke the function to get the child "describe" and "it" blocks.
        fn = @func()
        if fn?
            resetGlobalArrays()
            fn()
            @descriptions.add new Describe desc for desc in HARNESS.descriptions
            @its.add new It(it) for it in HARNESS.its
            resetGlobalArrays()
        
        
    
  # PRIVATE --------------------------------------------------------------------------
  
  resetGlobalArrays = -> HARNESS.descriptions = []
  
  
  # Collection.
  class Describe.Collection extends module.mvc.Collection
    model: Describe
    comparator: (model) -> model.title()
  
  
  # Export.
  Describe
  
