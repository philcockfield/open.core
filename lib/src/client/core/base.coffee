Property = require './util/property'

###
Common base class.
This class can either be extended using standard CoffeeScript syntax (class Foo extends Base)
or manually via underscore (_.extend source, new Base())

  OPTIONAL OVERRIDES: 
  - onPropAdded(prop)  : Invoked when a property is added.
  - onChanged(args)    : Invokd when a property value changes.
                         args:
                            - property : The property that has changed
                            - oldValue : The old value changing from.
                            - newValue : The new value changing to.
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
            
            # Alert deriving class (if listener method is implemented).
            self.onPropAdded(prop) if self.onPropAdded? 
            
            # Monitor changes (if listener method is implemented).
            if self.onChanged?
                monitorChange = (p)-> 
                  p.fn.onChanged (e) -> self.onChanged(e)
                monitorChange prop
  
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

  
  ###
  Attaches to an event on an object and refires it from this object.
  @param eventName    : The name of the event to bubble.
  @param eventSource  : The child object that will originally fire the event.
  ###
  bubble: (eventName, eventSource) -> 
      
      # Ensure this object supports eventing.
      _.extend(@, Backbone.Events) if not @.bind?
      
      # Bind to the event.
      eventSource.bind eventName, (args = {}) => 
          args.source = @
          @trigger eventName, args
      
      # Finish up (chainable).
      @
      
