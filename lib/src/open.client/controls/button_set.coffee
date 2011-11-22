core = require '../core'


###
Manages a set of toggle buttons providing single-selection 
behavior (for example, a tab set).

Events:
  - add               : Fires when a button is added to the collection.
  - remove            : Fires when a button is removed from the colletion.
  - clear             : Fires when the collection of buttons is cleared.
  - selectionChanged  : Fires when the selectin changes (does not fire on multiple clicks to the selected button).
  
  - mouseUp           : Fires on the [mouseup] event for each button (irrespective of whether the button is selected).
  - mouseDown         : Fires on the [mousedown] event for each button (irrespective of whether the button is selected).
  - click             : Fires on the [click] event for each button.
  - pre:click         : Fires on the [pre:click] event for each button.
  
###
module.exports = class ButtonSet extends core.Base
  constructor: -> 
    # Setup initial conditions.
    super
    _.extend @, Backbone.Events
    
    # Collection API.
    @length = 0
    @items  = new core.mvc.Collection()
  
  
  # Gets the collection of buttons being managed.
  items: undefined  # Set in constructor.
  
  
  # Method for enumerating each tab (alias for items.each)
  each: (fn) -> @items.each fn
  
  
  # Gets the number of items in the set.
  count: -> @items.length
  
  
  ###
  Retrieves the button model from the [Items] collection at the specified index.
  @param index: The index within the collection (0-based)
  @returns the specified button, or null.
  ###
  item: (index) -> @items.models[index]
  
  
  # Retrieves the currently selected toggle-button.
  selected: -> (@items.select (btn) -> btn.canToggle() and btn.selected())[0]
  
  
  # Selects the buttons that can be toggled.
  togglable: -> @items.select (btn) -> btn.canToggle()
  
  
  # Retrieves the first button in the set.
  first: -> @items.first()
  
  
  # Retrieves the last button in the set.
  last: -> @items.last()
  
  
  ###
  Adds a button to the set.
  @param button : The button to add.
  @param options
            silent: supresses the 'add' event (default false).
  @returns the added button.
  ###
  add: (button, options = {}) -> 
    # Setup initial conditions.
    throw 'add: no button' unless button?
    return button if @items.include(button)
    
    # Add the button to the collection.
    @items.add button, options
    @length = @items.length
    
    # Handle pre-click.
    button.bind 'pre:click', (e) -> 
      # Do not allow a selected button to be de-selected.
      e.cancel = true if button.selected()
      fire 'pre:click', e
    
    # Bubble events.
    fire = (event, e) => @trigger event, args:e, button:button
    button.el.mouseup   (e) -> fire 'mouseUp', e
    button.el.mousedown (e) -> fire 'mouseDown', e
    button.onClick      (e) -> fire 'click', e
    
    # Handle button press.
    button.selected.onChanged (e) => 
      return unless button.canToggle()
      return if e.oldValue == true
      
      # Deselect the other toggle buttons.
      for btn in @togglable()
          if btn isnt button and btn.canToggle() and btn.selected()
              btn.selected false
      
      # Alert listeners.
      @_fire 'selectionChanged', button:button
          
    # Finish up.
    if not options.silent
      @_fire 'add', button:button
      @_fireChanged()
    button
  
  
  ###
  Removes the specified button from the set.
  @param button: The button to remove.
  @param options
            silent: supresses the 'remove' event (default false).
  @returns true if the button was removed, of false if the button did not exist in the set.
  ###
  remove: (button, options = {}) -> 
    # Setup initial conditions.
    throw 'remove: no button' unless button?
    return false if not @items.include(button)
    options._fireChanged ?= true
    
    # Add the button to the collection.
    @items.remove button, options
    @length = @items.length
    
    # Unbind from events.
    button.unbind 'pre:click'
    button.unbind 'click'
    button.selected.unbind 'changed'
    button.el.unbind 'mouseup'
    button.el.unbind 'mousedown'
    
    # Finish up.
    if not options.silent
        @_fire 'remove', button:button
        @_fireChanged() if options._fireChanged
    true

  
  ###
  Removes all buttons from the set.
  @param options
            silent: supresses the 'remove' event (default false).
  ###
  clear: (options = {}) -> 
    # Setup initial conditions.
    options.silent ?= false
    options._fireChanged = false
    
    # Remove all items from the buttons collection.
    buttons = @items.select -> true
    for btn in buttons
        @remove btn, options
      
    # Alert listeners.
    if not options.silent
        @_fire 'clear' 
        @_fireChanged()
    
    # Finish up.
    null
  
  
  ###
  Determines whether the specified button exists within the set.
  @param button : The button to look for.
  @returns True if the button exists, otherwise False.
  ###
  contains: (button) -> @items.include button
  
  
  ###
  Retrieves the sibling immediately previous to the given button.
  @param button : The button to retrieve the sibling of.
  @returns the previous button, or null if there is no previous button.
  ###
  previous: (button) -> @items.models[@items.indexOf(button) - 1]
  
  
  ###
  Retrieves the sibling immediately next to the given button.
  @param button : The button to retrieve the sibling of.
  @returns the next button, or null if there is no next button.
  ###
  next: (button) -> 
    index = @items.indexOf(button)
    index += 1 unless index is -1
    @items.models[index]
  
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  _fire: (event, args = {}) -> 
    args.source = @
    @trigger event, args
  _fireChanged: -> @_fire 'changed'
  
  
  
  
  
  