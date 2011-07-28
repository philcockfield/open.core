PropFunc = require './util/prop_func'

merge = (source = {}, target = {}) -> 
    for key of source
        throw "[#{key}] exists" if target.hasOwnProperty(key)
        target[key] = source[key]
    target
  
  

###
Common base class.
###
module.exports = class Base
  constructor: ->
          # Setup initial conditions.
          util = @util
          util._parent = @
          
          # Prepare the internal state object.
          _internal =
             merge: (obj) -> 
                  merge(obj, _internal)
          @_ = _internal
          
          # Enable eventing.
          _.extend @, Backbone.Events


  ###
  Common utility functionality for the class.
  ###
  util:
      ###
      Merges the properties from the source object onto the target object.
      @returns: The target object.
      
      Example: Use this in a constructor to merge 'params' with more parameter
              values that you are passing up to the base class via 'super':
      
                 class MyClass extends Base
                   constructor: (params) ->
                       super @util.merge params, { myParam: 1234 }
      ###
      merge: (source, target) -> merge(source, target)
      
      
      ###
      Adds one or more [PropFunc] properties to the object.
      @param props : Object literal describing the properties to add
                     The object takes the form [name: default-value].
                     {
                        name: 'default value'
                     }
      ###
      addProp: (props) -> 
          
          # Setup initial conditions.
          return unless props?
          parent = @_parent
          store = parent._.basePropStore ?= {}
          
          add = (name) -> 
              defaultValue = props[name]
              prop = new PropFunc
                              name:     name
                              default:  defaultValue
                              store:    store
              parent[name] = prop.fn
          
          # Add each property.
          for name of props
              throw "[#{name}] exists" if parent.hasOwnProperty(name)
              add name









