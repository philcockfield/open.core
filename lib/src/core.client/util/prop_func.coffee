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



  ###
  The read/write function of the property.
  @param value (optional) the value to assign.  
               Do not specify (undefined) for read operations.
  ###
  fn: (value) -> 
      # Setup initial conditions.
      store = @_.store      
      
      # Write value.
      if value != undefined
          store[@name] = value

      # Read value.
      value = store[@name]
      value = @_.default if value == undefined
      value
