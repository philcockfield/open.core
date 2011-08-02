Base = require '../base'

excludeMethods = [
  'initialize'
  'idAttribute'
]

excludeMethod = (name) -> 
    return true if name.substring(0, 1) is '_'
    return true if _.any(excludeMethods, (m) -> m == name)
    false

###
Provides standardized response behavior for all of the server
interaction methods. 
- Fetch
- Save
- Destroy
###
serverMethod = (model, wrappedMethod) -> 
    #  Proxy to the underlying Backbone method.
    fnProxy = (options = {}) -> 
        onComplete = (response, success, error, callback) -> 
                args = 
                    model:    model
                    response: response
                    success:  success
                    error:    error
                fnProxy.trigger 'complete', args
                callback?(args)
    
        # Execute the method, with callbacks to the standard response handler.
        fnProxy._wrapped
            success: (m, response) -> onComplete(response, true, false, options.success)
            error:   (m, response) -> onComplete(response, false, true,  options.error)
            

    #  Extend the method.
    _.extend fnProxy, Backbone.Events
    fnProxy.onComplete = (handler) -> fnProxy.bind 'complete', handler
    fnProxy._wrapped = wrappedMethod # Exposed for testing puroses (allow spy override)
    fnProxy
    


###
Base class for models.
###
class Model extends Base
  constructor: (params = {}) ->
        # Setup initial conditions.
        super
        self = @
        # fnFetch = @fetch

        # Create the wrapped Backbone model.
        model = new Backbone.Model()

        # Store internal state.
        @_.merge
            model: model

        # Extend members.
        @fetch    = serverMethod(@, model.fetch)
        @save     = serverMethod(@, model.save)
        @destroy  = serverMethod(@, model.destroy)
        
        # Copy members from Backbone model.
        for key of model
            continue if @[key] != undefined or excludeMethod(key)
            @[key] = model[key]
        @atts = @attributes
        
        

  # Override: Return the custom property store function ferrys
  #           read/write requests into the backing Backbone model.
  propertyStore: -> 
      model = @_.model
      fnStore = (name, value) -> 
          if value != undefined
                #  Write value to backing model.
                param = {}
                param[name] = value
                model.set param
          
          # Read value from backing model.
          model.get(name)

      
        
  ###
  Fetches the model's state from the server.
  @param options
          - error(model, response)   : (optional) Function to invoke if an error occurs.
          - success(model, response) : (optional) Function to invoke upon success.
  # See backbone.js documentation for more details.
  ###
  fetch: undefined   # Set in constructor.
  
  # Saves the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  save: undefined   # Set in constructor.

  # Destroys the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  destroy: undefined   # Set in constructor.


              
              
              
     
# Export.
module.exports = Model
              
              
              
              
              
              
              
              
              
      