###
Model: Represents a specifications 'describe' block.
###
module.exports = (module) ->
  Spec      = module.model 'spec'
  Operation = module.model 'operation'
  
  class Suite extends module.mvc.Model
    defaults:
        title:          null
        summary:        null
        func:           null
        isInitialized:  false
    
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
        @beforeEach   = new Operation.Collection()
        @afterEach    = new Operation.Collection()
        @beforeAll    = new Operation.Collection()
        @afterAll     = new Operation.Collection()
        @specs        = new Spec.Collection()
        
        # Store parts.
        @title params[0]
        @summary params[1] if _(params[1]).isString()
        @func last if _(last).isFunction()
    
    
    ###
    Invokes the 'describe' function to get child specs and suites.
    ###
    init: -> 
        # Setup initial conditions.
        return if @isInitialized() is yes
        @isInitialized yes
        
        # Invoke the function to get the child "describe" and "it" blocks.
        fn = @func()
        if fn?
            # Clear the cache of params and run the test function, which will fill the cache again.
            resetGlobalArrays()
            fn()
            
            # Collect each type of operation.
            Suite.getSuites     @childSuites
            Suite.getBeforeEach @beforeEach
            Suite.getAfterEach  @afterEach
            Suite.getBeforeAll  @beforeAll
            Suite.getAfterAll   @afterAll
            Suite.getSpecs      @specs, @
            
            # Re-clear the cache.
            resetGlobalArrays()
  
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  resetGlobalArrays = -> 
        HARNESS.suites     = []
        HARNESS.specs      = []
        HARNESS.beforeEach = []
        HARNESS.afterEach  = []
        HARNESS.beforeAll  = []
        HARNESS.afterAll   = []

  
  getFunctions = (collection, items, fnModel) -> collection.add fnModel(item) for item in items
  getOperations = (collection, items) -> getFunctions collection, items, (params) -> new Operation(params)
  
  # Static methods.
  Suite.getSuites     = (collection)        -> getFunctions collection, HARNESS.suites, (params) -> new Suite(params)
  Suite.getBeforeEach = (collection)        -> getOperations collection, HARNESS.beforeEach
  Suite.getAfterEach  = (collection)        -> getOperations collection, HARNESS.afterEach
  Suite.getBeforeAll  = (collection)        -> getOperations collection, HARNESS.beforeAll
  Suite.getAfterAll   = (collection)        -> getOperations collection, HARNESS.afterAll
  Suite.getSpecs      = (collection, suite) -> getFunctions collection, HARNESS.specs, (params) -> new Spec(params, suite)
  
  
  
  # Collection.
  class Suite.Collection extends module.mvc.Collection
    model: Suite
    comparator: (model) -> model.title()
  
  
  # Export.
  Suite
  
