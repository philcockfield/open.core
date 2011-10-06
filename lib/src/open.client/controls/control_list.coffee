core = require '../core'

###
A vertical or horizontal set of controls stored in a UL.
###
module.exports = class ControlList extends core.mvc.View
  constructor: -> 
      super tagName: 'ul', className: @_className('control_list')
      @controls = new core.mvc.Collection()
  
  
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
