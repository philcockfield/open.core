###
A function which is used as a property.
Create an instance of this class and assign the 'fn' to a property on an object. 
Usage:
- Read:  the 'fn' function is invoked with no parameter.
- Write: the 'fn' function is invoekd with a value parameter.
###
module.exports = class PropFunc
  ###
  Constructor.
  @param options
            - name:   (required) The name of the property.
            - store:  (required) Either the object to store values in (using the 'name' as key)
                                 of a function used to read/write values to another store.
            - default: (optional) The default value to use.
  ###
  constructor: (options = {}) -> 
      @name = options.name
      @_ = 
          store:    options.store
          default:  options.default ?= null
      _.extend @, Backbone.Events


  ###
  The primary read/write function of the property.
  Expose this from your objects as a property-func.
  @param value (optional) the value to assign.  
               Do not specify (undefined) for read operations.
  ###
  fn: (value) -> 
      @write(value) if value != undefined
      @read()


  ###
  Reads the property value.
  ###
  read: -> 
      store = @_.store      
      value = store[@name]
      value = @_.default if value == undefined
      value


  ###
  Writes the given value to the property.
  ###
  write: (value) -> 
      return if value == undefined
      store = @_.store      
      store[@name] = value



