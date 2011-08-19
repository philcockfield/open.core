core = require 'open.client/core'

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
      @buttons = new core.mvc.Collection()
      @contains = @buttons.include
      

  ###
  Gets the collection of buttons being managed.
  ###
  buttons: undefined  # Set in constructor.

  
  ###
  Retrieves the collection of toggle-buttons that are currently in a selected state.
  ###
  selected: -> (@buttons.select (btn) -> btn.canToggle() and btn.selected())[0]

  ###
  Selects the buttons that can be toggled.
  ###
  togglable: -> @buttons.select (btn) -> btn.canToggle()


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
      return button if @buttons.include(button)
      
      # Add the button to the collection.
      @buttons.add button, options
      @length = @buttons.length
      
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
      return false if not @buttons.include(button)
      options._fireChanged ?= true
      
      # Add the button to the collection.
      @buttons.remove button, options
      @length = @buttons.length
      
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
      buttons = @buttons.select -> true
      for btn in buttons
          @remove btn, options
          # @buttons.remove btn, options
        
      # Alert listeners.
      if not options.silent
          @_fire 'clear' 
          @_fireChanged()

      # Finish up.
      null

  ###
  PRIVATE Methods
  ###
  _fire: (event, args = {}) -> 
      args.source = @
      @trigger event, args
  _fireChanged: -> @_fire 'changed'
  
  
  
  
  
  