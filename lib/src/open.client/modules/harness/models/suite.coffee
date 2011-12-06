###
Model: Represents a 'describe' block.


Declared using the following configurations:

  describe 'text description', ->
  describe 'text description', 'summary...' ->
  describe 'text description', {options} ->
  describe 'text description', 'summary...', {options} ->
  
  Options:
    - sortSuites:   Boolean. Sort order for child suites. (default: false)
    - sortSpecs:    Boolean. Sort order for child specs.  (default: false)

###
module.exports = (module) ->
  Spec      = module.model 'spec'
  Operation = module.model 'operation'
  
  
  class Suite extends module.mvc.Model
    defaults:
        title:          null
        summary:        null
        func:           null
        options:        null
        isInitialized:  false
    
    ###
    Constructor.
    @param params:      The array of arguments retreived from the "describe" function.
                        This will be a set of strings:
                        [0]: The title
                        [1]: Summary or options (optional).
                        [2]: options (optional).
    @param parentSuite: The parent suite if this is not a root suite.
    ###
    constructor: (params, @parentSuite) -> 
        
        # Setup initial conditions.
        super
        params      = [params] unless _(params).isArray()
        firstParam  = params[0]
        secondParam = params[1]
        thirdParam  = params[2]
        lastParam   = _(params).last()
        
        # Collections.
        @childSuites  = new Suite.Collection()
        @beforeEach   = new Operation.Collection()
        @afterEach    = new Operation.Collection()
        @beforeAll    = new Operation.Collection()
        @afterAll     = new Operation.Collection()
        @specs        = new Spec.Collection()
        
        # Store parts.
        @title firstParam if _(firstParam).isString()
        @func lastParam if _(lastParam).isFunction()
        
        if _(secondParam).isString()
          # Second parameter is summary text.
          @summary secondParam if _(params[1]).isString()
        else if not _(secondParam).isFunction()
          # Second parameter is an options object.
          @options secondParam
        
        if params.length >= 3 and   (not _(thirdParam).isFunction())
          # Thrid parameter is an options object.
          @options thirdParam
        
        # Ensure there is an options object.
        @options {} unless @options()?
        options       = @options()
        parentOptions = @parentSuite?.options()
        
        # Set option defaults.
        defaultFromParent = (propName, defaultValue) => 
          options[propName] ?= ( if parentOptions? then parentOptions[propName] else defaultValue )
        defaultFromParent 'sortSuites', false
        defaultFromParent 'sortSpecs', false
        
        # Store this instance in the flat master list of suites.
        Suite.all.add @
        
        # Finish up.
        @id = createId @
    
    
    ###
    Invokes the 'describe' function to get child specs and suites.
    ###
    init: -> 
      # Setup initial conditions.
      return if @isInitialized() is yes
      @isInitialized yes
      options = @options()
      
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
          
        # Set sorting on collection (if required).
        sort = (collection, doSort) => 
          return unless doSort is yes
          collection.comparator = (model) -> model.title()
          collection.sort()
        sort @childSuites, options.sortSuites
        sort @specs, options.sortSpecs
    
    
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
  
  
  createId = (suite, childId = null) -> 
        
        # Setup initial conditions.
        id = formatId suite.title()
        return null unless id?
        
        # Prepend the child-ID (if passed from recursive call).
        id = "#{id}/#{childId}" if childId?
        
        # Prepend the parent part of the id
        parent = suite.parentSuite
        if parent?
            id = createId suite.parentSuite, id  # <== RECURSION
        
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
  
  getOperations = (type, collection, suite, items) -> 
      getFunctions collection, items, (fnOperation) -> 
          new Operation 
                    type:  type
                    suite: suite
                    func:  fnOperation
  
  
  # STATIC MEMBERS --------------------------------------------------------------------------
  
  
  Suite.getSuites     = (collection, suite) -> getFunctions collection, HARNESS.suites, (params) -> new Suite(params, suite)
  Suite.getBeforeEach = (collection, suite) -> getOperations 'beforeEach', collection, suite, HARNESS.beforeEach
  Suite.getAfterEach  = (collection, suite) -> getOperations 'afterEach',  collection, suite, HARNESS.afterEach
  Suite.getBeforeAll  = (collection, suite) -> getOperations 'beforeAll',  collection, suite, HARNESS.beforeAll
  Suite.getAfterAll   = (collection, suite) -> getOperations 'afterAll',   collection, suite, HARNESS.afterAll
  Suite.getSpecs      = (collection, suite) -> getFunctions collection, HARNESS.specs, (params) -> new Spec(params, suite)
  
  
  # COLLECTION --------------------------------------------------------------------------
  
  
  class Suite.Collection extends module.mvc.Collection
    model: Suite
  
  
  # A collection that contains a flat list of all suites.
  Suite.all = new Suite.Collection()
  
  
  # Export.
  Suite
  
