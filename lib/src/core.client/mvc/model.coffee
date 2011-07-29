Base = require '../base'

###
Base class for models.
###
module.exports = class Model extends Base
  constructor: (params = {}) ->
        # Setup initial conditions.
        super
        self = @

        # Create the wrapped Backbone Model.
        model = new Backbone.Model()

        # Store internal state.
        @_.merge
            model: model
        
        # Event enable members.
        _.extend @fetch, Backbone.Events
        

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
      
      onComplete = (response, callback) -> 
          self.fetch.trigger 'complete', { model:self, response:response }
          callback?(self, response)
      
      model.fetch
          error: (m, res)  -> onComplete(res, options.error)
          success: (m, res) -> onComplete(res, options.success)
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
      