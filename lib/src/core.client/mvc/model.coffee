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

  # Override: Return the custom property store ferrying 
  #           read/write requests into the backing model.
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
      
  
      
      
      