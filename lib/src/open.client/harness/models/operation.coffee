###
Model: Represents a headless operation, such as a 'Setup' or 'Teardown' procedure.

Used for:
   
   - beforeEach
   - afterEach
   - beforeAll
   - afterAll
   
###
module.exports = (module) ->
  class Operation extends module.mvc.Model
    
    ###
    Constructor.
    @param params
             - type:    String representing the type of operation (eg. 'beforeAll' etc.)
             - suite:   The suite that the operation belongs to.
             - func:    The function for the operation.
    ###
    constructor: (params = {}) -> 
        
        # console.log 'params', params
        
        super
        @type  = params.type
        @suite = params.suite
        @func  = params.func
        @func = @func[0] if _(@func).isArray()
    
    
    ###
    Invokes the spec.
    ###
    invoke: -> 
        try
          @func?()
        catch error
          if console?
              console.log "Failed to invoke [#{@type}] in '#{@suite.title()}'."
              module.logError error
              console.log ''
  
  
  # Collection.
  class Operation.Collection extends module.mvc.Collection
    model: Operation
  
  
  # Export.
  Operation

