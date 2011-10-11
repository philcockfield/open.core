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
    @param func:    The function for the operation.
    @param suite:   The suite that the operation belongs to.
    ###
    constructor: (@func, @suite) -> 
        super
        @func = @func[0] if _(@func).isArray()
        
    
    ###
    Invokes the spec.
    ###
    invoke: -> 
        try
          @func?()
        catch error
          if console?
              console.log 'Failed to invoke operation.'
              console.log ' - Error: ', error
              console.log ''
  
  # Collection.
  class Operation.Collection extends module.mvc.Collection
    model: Operation
  
  
  # Export.
  Operation

