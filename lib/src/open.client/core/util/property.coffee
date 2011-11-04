###
A function which is used as a property.
Create an instance of this class and assign the 'fn' to a property on an object. 
Usage:
  - Read:  the 'fn' function is invoked with no parameter.
  - Write: the 'fn' function is invoekd with a value parameter.

Property events:
  - changing : Fires immediately before the property changes.  Event handler can mutate written property value.
  - changed  : Fires immediately after the property has changed.
  - reading  : Fires immediately before the property is read.  Event handler can mutate the read property value.

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
      
      # Store references.
      fn = @fn
      fn._parent = @
      @name = options.name
      @_ = 
          store:    options.store
          default:  options.default ?= null
      
      # Setup eventing.
      _.extend @, Backbone.Events
      _.extend fn, Backbone.Events
      
      # Add handler helper methods.
      fn.onChanging = (handler) -> fn.bind 'changing', handler
      fn.onChanged  = (handler) -> fn.bind 'changed',  handler
      fn.onReading  = (handler) -> fn.bind 'reading',  handler
      fn.toggle = -> 
          value = fn()
          fn(not value) if value is true or value is false
  
  
  ###
  The primary read/write function of the property.
  Expose this from your objects as a property-func.
  @param value (optional) the value to assign.  
               Do not specify (undefined) for read operations.
  @param options
            - silent : (optional) Flag indicating if events should be suppressed (default false).
            - *      : Any other arguments that are to be passed through on the event
  ###
  fn: (value, options) => 
      @write(value, options) if value != undefined
      @read()
  
  
  ###
  Reads the property value.
  ###
  read: => 
      
      # Retrieve the value.
      store = @_.store      
      if _.isFunction(store) then value = store(@name) else value = store[@name]
      value = @_.default if value == undefined
      
      # Pre-event.
      args = @fireReading value
      value = args.value # Return any mutation of the value an event handler may have made.
      
      # Finish up.
      value
  
  
  ###
  Writes the given value to the property.
  @param value : The value to write.
  @param options
            - silent : (optional) Flag indicating if events should be suppressed (default false).
            - *      : Any other arguments that are to be passed through on the event
  ###
  write: (value, options = {}) => 
      # Setup initial conditions.
      return if value == undefined
      oldValue = @read()
      return if value == oldValue
      options.silent ?= false
      
      # Pre-event.
      if options.silent is no
        args = @fireChanging oldValue, value, options
        return if args.cancel is yes
        value = args.newValue # Pick up any changes handlers may have made to the value.
      
      # Store the value.
      store = @_.store      
      if _.isFunction(store) then store(@name, value, options) else store[@name] = value
      
      # Post-event.
      @fireChanged(oldValue, value, options) if options.silent is no
  
  
  ###
  Fires the 'reading' event (from the [Property] instance, and the [fn] method)
  allowing listeners to mutate the returned value.
  @param value : The value of the property.
  @returns the event args.
  ###
  fireReading: (value) => 
      args = 
          value: value
      fireEvent 'reading', @, args
      args
  
  
  ###
  Fires the 'changing' event (from the [Property] instance, and the [fn] method)
  allowing listeners to cancel the change.
  @param oldValue : The value before the property is changing from.
  @param newValue : The new value the property is changing to.
  @param options  : Any options that were passed through when writing to the property.
  @returns the event args.
  ###
  fireChanging: (oldValue, newValue, options = {}) => 
      args = 
          oldValue: oldValue
          newValue: newValue
          cancel:   false
          options:  options
      fireEvent 'changing', @, args
      args
  
  
  ###
  Fires the 'changed' event (from the [Property] instance, and the [fn] method).
  @param oldValue : The value before the property is changing from.
  @param newValue : The new value the property is changing to.
  @param options  : Any options that were passed through when writing to the property.
  @returns the event args.
  ###
  fireChanged: (oldValue, newValue, options = {}) =>
      fireEvent 'changed', @,
                    oldValue: oldValue
                    newValue: newValue
                    options:  options


# PRIVATE --------------------------------------------------------------------------


fireEvent = (eventName, prop, args) => 
    args.property = prop
    fire = (obj) => obj.trigger eventName, args
    fire prop
    fire prop.fn
    args





