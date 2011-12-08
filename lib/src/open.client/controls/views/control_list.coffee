core = require 'open.client/core'
mvc  = core.mvc


###
A vertical or horizontal set of controls stored in a UL.
###
module.exports = class ControlList extends mvc.View
  defaults:
    orientation: 'y' # Gets or sets whether the list is vertical or horizontal. Values either 'x' or 'y'.
  
  constructor: (params = {}) -> 
      # Setup initial conditions.
      super _.extend params, tagName: 'ul', className: @_className('control_list')
      @controls = new mvc.Collection()
      
      # Wire up events.
      @orientation.onChanging (e) -> e.newValue = e.newValue.toLowerCase() # Ensure the value is lower-case.
      @orientation.onChanged  (e) => syncClasses @
      
      # Finish up.
      syncClasses @
  
  
  # Gets the total number of items within the controls collection.
  count: -> @controls.length
  
  
  # Gets the first control in the list (or null if the list is empty).
  first: -> @controls.first()
  
  
  # Gets the last control in the list (or null if the list is empty).
  last: -> @controls.last()
  
  
  ###
  Initializes the list with a set of controls.
  @param controls: The collection of button definitions to add.  
                   These are passed to the 'add' method.
  @returns the list instance.
  ###  
  init: (controls = []) -> 
    @clear()
    @add ctrl for ctrl in controls
    @
  
  
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
  
  
  ###
  Removes the given control from the list.
  @param control: The MVC [View] control to remove.
  @returns the list.
  ###
  remove: (control) -> 
    # Setup initial conditions.
    return @ unless control?
    @controls.remove control
    
    # Remove the corresponding <li>.
    for li in @$('li')
      li = $ li
      if li.children()[0] is control.el.get(0)
        li.remove()
        return @
    
    # Finish up.
    @
  
  
  ###
  Clears all items from the list.
  ###
  clear: -> @remove control for control in _.clone(@controls.models)


# PRIVATE --------------------------------------------------------------------------


syncClasses = (view) -> 
  toggle = (orientation) -> view.el.toggleClass view._className(orientation), (view.orientation() is orientation)
  toggle 'x'
  toggle 'y'


