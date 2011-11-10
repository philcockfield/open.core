###
Model: Represents a 'describe' block.
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
    @param params:      The array of arguments retreived from the "describe" function.
                        This will be a set of strings:
                        [0]: The title
                        [1]: Summary (optional).
    @param parentSuite: The parent suite if this is not a root suite.
    ###
    constructor: (params, @parentSuite) -> 
        
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
        @title params[0] if _(params[0]).isString()
        @summary params[1] if _(params[1]).isString()
        @func last if _(last).isFunction()
        @id = buildId @
        
        # Store this instance in the flat master list of suites.
        Suite.all.add @
    
    
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
            Suite.getSuites     @childSuites, @
            Suite.getBeforeEach @beforeEach, @
            Suite.getAfterEach  @afterEach, @
            Suite.getBeforeAll  @beforeAll, @
            Suite.getAfterAll   @afterAll, @
            Suite.getSpecs      @specs, @
            
            # Re-clear the cache.
            resetGlobalArrays()
    
    
    ###
    Retrieves the root spec in the hierarhcy, or this suite if it is the root.
    ###
    root: -> _(@ancestors()).last()
    
    
    ###
    Builds up list of ancestors of the suite.
    @param options:
              - includeThis : Flag indicating if this suite should be included in the list (default: true).
              - direction   : The order of the list.
                              - 'ascending'  : descendent to ancestor.
                              - 'descending' : ancestor descendent.
    @returns array of suites.
    ###
    ancestors: (options = {}) -> 
        
        # Setup initial conditions.
        list        = []
        includeThis = options.includeThis ? true
        direction   = options.direction ? 'ascending'
        
        # Walk up the hierarchy.
        get = (suite) -> 
                return unless suite?
                list.push suite
                get(suite.parentSuite) if suite.parentSuite?
        
        # Start the walk.
        startingSuite = if includeThis is yes then @ else @parentSuite
        get(startingSuite)
        
        # Sort order.
        list = list.reverse() if direction is 'descending'
        
        # Finish up.
        list
    
    

  
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  buildId = (suite, childId = null) -> 
        
        # Setup initial conditions.
        id = formatId suite.title()
        return null unless id?
        
        # Prepend the child-ID (if passed from recursive call).
        id = "#{id}/#{childId}" if childId?
        
        # Prepend the parent part of the id
        parent = suite.parentSuite
        if parent?
            id = buildId suite.parentSuite, id  # <== RECURSION
        
        # Finish up.
        id
  
  
  formatId = (raw) -> 
        return null unless raw?
        id = raw.replace /\//g, '\\' # Convert forward-spash to back-slash, so that it will be escaped.
        id = encodeURI(id)
        id = id.toLowerCase()
        id
  
  
  resetGlobalArrays = -> 
        HARNESS.suites     = []
        HARNESS.specs      = []
        HARNESS.beforeEach = []
        HARNESS.afterEach  = []
        HARNESS.beforeAll  = []
        HARNESS.afterAll   = []
  
  
  getFunctions = (collection, items, fnModel) -> 
      return unless items?
      collection.add fnModel(item) for item in items
  
  getOperations = (collection, suite, items) -> 
      getFunctions collection, items, (params) -> new Operation(params, suite)
  
  
  # STATIC MEMBERS --------------------------------------------------------------------------
  
  
  Suite.getSuites     = (collection, suite) -> getFunctions collection, HARNESS.suites, (params) -> new Suite(params, suite)
  Suite.getBeforeEach = (collection, suite) -> getOperations collection, suite, HARNESS.beforeEach
  Suite.getAfterEach  = (collection, suite) -> getOperations collection, suite, HARNESS.afterEach
  Suite.getBeforeAll  = (collection, suite) -> getOperations collection, suite, HARNESS.beforeAll
  Suite.getAfterAll   = (collection, suite) -> getOperations collection, suite, HARNESS.afterAll
  Suite.getSpecs      = (collection, suite) -> getFunctions collection, HARNESS.specs, (params) -> new Spec(params, suite)
  
  
  # COLLECTION --------------------------------------------------------------------------
  
  
  class Suite.Collection extends module.mvc.Collection
    model: Suite
    comparator: (model) -> model.title()
  
  
  # A collection that contains a flat list of all suites.
  Suite.all = new Suite.Collection()
  
  
  # Export.
  Suite
  
