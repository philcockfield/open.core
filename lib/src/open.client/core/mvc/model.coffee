Base   = require '../base'
common = require './_common'

basePrototype = new Base()

###
Base class for models.
###
module.exports = class Model extends Backbone.Model
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
          - error(args)   : (optional) Function to invoke if an error occurs.
          - success(args) : (optional) Function to invoke upon success.
                          result args:
                              - model    : The model.
                              - response : The response data.
                              - success  : {bool} Flag indicating if the operation was successful
                              - error    : {bool} Flag indicating if the operation was in error.
  # See backbone.js documentation for more details.
  ###
  fetch: (options) -> @_sync @, 'fetch', options
  
  # Saves the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  save: (options) -> @_sync @, 'save', options
  
  # Destroys the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  destroy: (options) -> @_sync @, 'destroy', options
  
  _sync: (model, methodName, options = {}) -> 
          fn = Backbone.Model.prototype[methodName]
          common.sync fn, model, methodName, options
      