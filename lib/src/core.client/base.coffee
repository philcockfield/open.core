Property = require './util/property'

###
Common base class.
This class can either be extended using standard CoffeeScript syntax (class Foo extends Base)
or manually via underscore (_.extend source, new Base())
###
module.exports = class Base

  ###
  Adds one or more [Property] functions to the object.
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
      
      # Add the [Property] to the object.
      add = (name) -> 
            defaultValue = props[name]
            prop = new Property
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

