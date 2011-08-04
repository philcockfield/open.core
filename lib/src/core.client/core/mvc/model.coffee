Base = require '../base'
basePrototype = new Base()



###
Base class for models.
###
class Model extends Backbone.Model
  constructor: (params = {}) ->
        # Setup initial conditions.
        super
        self = @
        
        # Extend from Base for auto properties.
        # Note:  Return the custom property store function that ferrys
        #        read/write requests into the Backbone model's GET/SET methods.
        _.extend @, basePrototype
        @propertyStore = () =>
            fn = (name, value) => 
                if value != undefined
                      #  Write value to backing store.
                      param = {}
                      param[name] = value
                      self.set param
          
                # Read value from backing model.
                self.get(name)

        # Extend members.
        do => 
            init = (method) -> 
                  _.extend method, Backbone.Events
                  method.onComplete = (handler) -> method.bind 'complete', handler
            init @fetch
            init @save
            init @destroy

  ###
  Fetches the model's state from the server.
  @param options
          - error(model, response)   : (optional) Function to invoke if an error occurs.
          - success(model, response) : (optional) Function to invoke upon success.
  # See backbone.js documentation for more details.
  ###
  fetch: (options) -> @_execServerMethod @, 'fetch', options
  
  # Saves the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  save: (options) -> @_execServerMethod @, 'save', options
  
  # Destroys the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  destroy: (options) -> @_execServerMethod @, 'destroy', options

  
  _execServerMethod: (model, methodName, options = {}) -> 
          onComplete = (response, success, error, callback) -> 
                  args = 
                      model:    model
                      response: response
                      success:  success
                      error:    error
                  model[methodName].trigger 'complete', args
                  callback?(args)
    
          # Execute the method, with callbacks to the standard response handler.
          Backbone.Model.prototype[methodName].call model,
              success: (m, response) -> onComplete(response, true, false, options.success)
              error:   (m, response) -> onComplete(response, false, true,  options.error)

              
              
              
     
# Export.
module.exports = Model
              
              
              
              
              
              
              
              
              
      