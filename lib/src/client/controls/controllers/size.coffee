###
Adds 'width' and 'height' properties to a view, and keeps
the element's size in sync with the values.

###
module.exports = class SizeController
  ###
  Constructor.
  @param view: The view to control.
  @param options
          - unit:  The size unit (default 'px').
  ###
  constructor: (view, options = {}) -> 
    
    # Setup initial conditions.
    options.unit ?= 'px'
    
    # console.log 'options.unit', options.unit
    
    addProp = (prop) -> 
      if view[prop]?
        if view[prop].onChanged?
          return # The propoerty function is already decalred.
        else
          throw "A non-property function '#{prop}' already declared."
      props       = {}
      props[prop] = null
      view.addProps props
    
    # Add properties.
    addProp 'width'
    addProp 'height'
    
    # Syncers.
    syncWidth  = -> sync 'width', view.width()
    syncHeight = -> sync 'height', view.height()
    sync = (style, value) -> 
      value = value + options.unit if value?
      view.el.css style, value
      
    # Wire up events.
    view.width.onChanged -> syncWidth()
    view.height.onChanged -> syncHeight()
    
    # Finish up.
    syncWidth()
    syncHeight()
    
    
    
      