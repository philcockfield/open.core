core = require '../core'

###
A vertical or horizontal set of controls stored in a UL.
###
module.exports = class ControlList extends core.mvc.View
  defaults:
    orientation: 'y' # Gets or sets whether the list is vertical or horizontal. Values either 'x' or 'y'.
  
  constructor: (params = {}) -> 

      # Setup initial conditions.
      super _.extend params, tagName: 'ul', className: @_className('control_list')
      @controls = new core.mvc.Collection()
      
      # Wire up events.
      @orientation.onChanging (e) -> e.newValue = e.newValue.toLowerCase() # Ensure the value is lower-case.
      @orientation.onChanged  (e) => syncClasses @
      
      # Finish up.
      syncClasses @
  
  
  ###
  Adds a control to the list.
  @param control: The MVC [View] control to add.
  @returns the added control
  ###
  add: (control) -> 
      
      # Store reference to contol in collection.
      @controls.add control
      
      # Prepare for DOM.
      li = $('<li></li>')
      li.append control.el
      @el.append li
      
      # Finish up.
      control



# PRIVATE --------------------------------------------------------------------------

syncClasses = (view) -> 
  toggle = (orientation) -> view.el.toggleClass view._className(orientation), (view.orientation() is orientation)
  toggle 'x'
  toggle 'y'
  
  
  