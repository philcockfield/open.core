# TODO - changing / changed events


###
A function which is used as a property.
Create an instance of this class and assign the 'fn' to a property on an object. 
Usage:
- Read:  the 'fn' function is invoked with no parameter.
- Write: the 'fn' function is invoekd with a value parameter.
###
module.exports = class Property
  ###
  Constructor.
  @param options
            - name:    (required) The name of the property.
            - store:   (required) Either the object to store values in (using the 'name' as key)
                                  of a function used to read/write values to another store.
            - default: (optional) The default value to use.
  ###
  constructor: (options = {}) -> 
      fn = @fn
      @name = options.name
      @_ = 
          store:    options.store
          default:  options.default ?= null
      _.extend @, Backbone.Events
      _.extend fn, Backbone.Events
      fn._parent = @


  ###
  The primary read/write function of the property.
  Expose this from your objects as a property-func.
  @param value (optional) the value to assign.  
               Do not specify (undefined) for read operations.
  ###
  fn: (value) => 
      @write(value) if value != undefined
      @read()


  ###
  Reads the property value.
  ###
  read: => 
      store = @_.store      
      if _.isFunction(store) then value = store(@name) else value = store[@name]
      value = @_.default if value == undefined
      value


  ###
  Writes the given value to the property.
  ###
  write: (value) => 
      # Setup initial conditions.
      return if value == undefined
      oldValue = @read()
      return if value == oldValue
      
      # Store the value.
      store = @_.store      
      if _.isFunction(store) then store(@name, value) else store[@name] = value
      
      # Alert listeners.
      @fireChange oldValue, value


  ###
  Fires the change event (from the [Property] instance, and the [fn] method).
  @param oldValue : The value before the property is changing from.
  @param newValue : The new value the property is changing to.
  ###
  fireChange: (oldValue, newValue) => 
      fire = (obj) => 
              obj.trigger 'change', { oldValue:oldValue, newValue:newValue }
      fire @
      fire @fn

