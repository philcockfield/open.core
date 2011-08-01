Base = require '../base'

excludeMethods = [
  'initialize'
]


excludeMethod = (name) -> 
    
    return true if name.substring(0, 1) is '_'
    return true if _.any(excludeMethods, (m) -> m == name)
    
    false
    


###
Base class for models.
###
module.exports = class Model extends Base
  constructor: (params = {}) ->
        # Setup initial conditions.
        super
        self = @
        fnFetch = @fetch

        # Create the wrapped Backbone Model.
        model = new Backbone.Model()

        # Store internal state.
        @_.merge
            model: model
        
        # Copy members from Backbone model.
        for key of model
            continue if @[key] != undefined
            continue if excludeMethod(key)
            @[key] = model[key]
        
        # Extend members with events.
        _.extend fnFetch, Backbone.Events
        
        # Add event-handler helpers.
        fnFetch.onComplete = (handler) -> fnFetch.bind 'complete', handler
        
        

  # Override: Return the custom property store function ferrys
  #           read/write requests into the backing Backbone model.
  _propertyStore: -> 
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
  ###
  fetch: (options = {}) ->     
      self = @
      model = @_.model
      
      onComplete = (response, success, error, callback) -> 
          args = 
              model:    self
              response: response
              success:  success
              error:    error
          self.fetch.trigger 'complete', args
          callback?(args)
      
      model.fetch
          success: (m, res) -> onComplete(res, true, false, options.success)
          error:   (m, res) -> onComplete(res, false, true,  options.error)
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
      