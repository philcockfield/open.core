###
Model: Represents a specifications 'describe' block.
###
module.exports = (module) ->
  It = module.model 'it'
  
  class Suite extends module.mvc.Model
    defaults:
        title:    null
        summary:  null
        func:     null
    
    ###
    Constructor.
    @param params: The array of arguments retreived from the "describe" function.
    ###
    constructor: (params) -> 
        
        # Setup initial conditions.
        super
        params = [params] unless _(params).isArray()
        last = _(params).last()
        
        # Collections.
        @childSuites  = new Suite.Collection()
        @its          = new It.Collection()
        
        # Store parts.
        @title params[0]
        @summary params[1] if _(params[1]).isString()
        @func last if _(last).isFunction()
    
    
    ###
    Invokes the 'describe' function to get child specs and suites.
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
            @childSuites.add new Suite desc for desc in HARNESS.suites
            @its.add new It(it) for it in HARNESS.specs
            resetGlobalArrays()
        
        
    
  # PRIVATE --------------------------------------------------------------------------
  
  resetGlobalArrays = -> 
        HARNESS.suites = []
        HARNESS.specs = []
  
  
  # Static methods.
  
  
  # Collection.
  class Suite.Collection extends module.mvc.Collection
    model: Suite
    comparator: (model) -> model.title()
  
  
  # Export.
  Suite
  
