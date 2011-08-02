PropFunc = require './util/prop_func'

merge = (source = {}, target = {}) -> 
    for key of source
        throw "Merge fail. [#{key}] exists" if target.hasOwnProperty(key)
        target[key] = source[key]
    target


###
Common base class.
This class can either be extended using standard CoffeeScript syntax (class Foo extends Base)
or manually via underscore (_.extend source, new Base())
###
module.exports = class Base

  ###
  Adds one or more [PropFunc] properties to the object.
  @param props :    Object literal describing the properties to add
                    The object takes the form [name: default-value].
                    {
                      name: 'default value'
                    }
  ###
  addProps: (props) ->

      # Setup initial conditions.
      return unless props?
      self = @
      store = @propertyStore()
      
      # Add the PropFunc to the object.
      add = (name) -> 
            defaultValue = props[name]
            prop = new PropFunc
                            name:     name
                            default:  defaultValue
                            store:    store
            self[name] = prop.fn
  
      # Add each property.
      for name of props
          throw "Add property fail. [#{name}] exists" if @.hasOwnProperty(name)
          add name


  

  ###
  Retrieves the property store.
  This should be either an object or a property-function. 
  Override this to provide a custom property store.
  ###
  propertyStore: -> 
      internal = @_ ?= {}
      internal.basePropertyStore ?= {}




