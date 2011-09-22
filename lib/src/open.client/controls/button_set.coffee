core = require '../core'

###
Manages a set of toggle buttons providing single-selection 
behavior (for example, a tab set).

Events:
  - add
  - remove
  - clear
  - selectionChanged

###
module.exports = class ButtonSet extends core.Base
  constructor: -> 
      # Setup initial conditions.
      super
      _.extend @, Backbone.Events
      
      # Collection API.
      @length = 0
      @items = new core.mvc.Collection()
      

  ###
  Gets the collection of buttons being managed.
  ###
  items: undefined  # Set in constructor.
  
  ###
  Retrieves the button model from the [Items] collection at the specified index.
  @param index: The index within the collection (0-based)
  @returns the specified button, or null.
  ###
  item: (index) -> @items.models[index]
  
  
  ###
  Retrieves the collection of toggle-buttons that are currently in a selected state.
  ###
  selected: -> (@items.select (btn) -> btn.canToggle() and btn.selected())[0]

  ###
  Selects the buttons that can be toggled.
  ###
  togglable: -> @items.select (btn) -> btn.canToggle()


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
      
      # Handler pre-click.
      button.bind 'pre:click', (e) -> 
          # Do not allow a selected button to be de-selected.
          e.cancel = true if button.selected()
      
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
          @_fire 'add' 
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
      button.selected.unbind 'changed'
      
      # Finish up.
      if not options.silent
          @_fire 'remove' 
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
  PRIVATE Methods
  ###
  _fire: (event, args = {}) -> 
      args.source = @
      @trigger event, args
  _fireChanged: -> @_fire 'changed'
  
  
  
  
  
  