Base   = require '../base'
common = require './_common'
basePrototype = new Base()

###
Base class for models.
###
module.exports = class Model extends Backbone.Model
  constructor: (params = {}) -> Model::_construct.call @, params
  
  
  ###
  Called internally by the constructor.  
  Use this if properties are added to the object after 
  construction and you need to re-run the constructor,
  (eg. within a functional inheritance pattern).
  ###
  _construct: (params = {}) -> 
      
      # Setup initial conditions.
      Model.__super__.constructor.call @, params
      self = @
      
      # Extend from Base for auto properties.
      # Note:  Return the custom property store function that ferrys
      #        read/write requests into the Backbone model's GET/SET methods.
      _.extend @, basePrototype
      @propertyStore = () =>
          fn = (name, value, options) => 
              if value != undefined
                    #  Write value to backing store.
                    param = {}
                    param[name] = value
                    self.set param, options
              
              # Read value from backing model.
              self.get(name)
      
      # Add defaults as Property functions.
      @addProps @defaults
      
      # Overide server interaction methods.
      # NB: These are set in the constructor for each instance (and not on the class itself)
      #     to avoid event hookups on these methods firing for all created model, not just
      #     this particular instance.
      @fetch   = (options) -> @_sync @, 'fetch', options
      @save    = (options) -> @_sync @, 'save', options
      @destroy = (options) -> @_sync @, 'destroy', options
      
      # Extend members.
      do => 
          init = (method) -> 
                _.extend method, Backbone.Events
                method.onStart    = (handler) -> method.bind 'start', handler
                method.onComplete = (handler) -> method.bind 'complete', handler
          init @fetch
          init @save
          init @destroy
      
      # Property aliases.
      @atts = @attributes
  
  
  ###
  Retrieves the [id] if it exists, otherwise returns the [cid].
  ###
  identifier: -> @id ?= @cid
  
  ###
  Adds one or more [Property] functions to the object.
  @param props :    Object literal describing the properties to add
                    The object takes the form [name: default-value].
                    {
                      name: 'default value'
                    }
  ###
  addProps: (props) -> 
        

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
  
  Listening to events.
    This function fires 'start' and 'complete' events, eg: model.fetch.bind 'start', (e) -> 
    Alternatively you can use the [onStart] and [onComplete] event handler methods, eg:
        
        model.fetch.onComplete (e) -> 
        
  ###
  fetch: undefined   # Set in constructor
  
  # Saves the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  save: undefined   # Set in constructor
  
  # Destroys the model on the server.
  # Params: same as fetch
  # See backbone.js documentation for more details.
  destroy: undefined   # Set in constructor
  
  _sync: (model, methodName, options = {}) -> 
          fn = Backbone.Model.prototype[methodName]
          common.sync fn, model, methodName, options
      
