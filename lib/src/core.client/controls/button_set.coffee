core = require 'core.client/core'

###
Manages a set of toggle buttons providing single-selection 
behavior (for example, a tab set).
###
module.exports = class ButtonSet extends core.Base
  constructor: () -> 
      super
      _.extend @, Backbone.Events
      @length = 0
      @buttons = new core.mvc.Collection()

  ###
  Gets the collection of buttons being managed.
  ###
  buttons: undefined  # Set in constructor.
  
  
  ###
  Retrieves the collection of toggle-buttons that are currently in a pressed state.
  ###
  selected: -> (@buttons.select (btn) -> btn.canToggle() and btn.pressed())[0]


  ###
  Selects the buttons that can be toggled.
  ###
  togglable: -> @buttons.select (btn) -> btn.canToggle()


  ###
  Adds a button to the set.
  @param button : The button to add.
  @param options
            silent: supresses the 'remove' event (default false).
  ###
  addButton: (button, options = {}) -> 
      
      # Setup initial conditions.
      throw 'no button' unless button?
      
      #  Add the button to the collection.
      @buttons.add button, options
      @length = @buttons.length
      
      # Handler pre-click.
      button.bind 'pre:click', (e) -> 
          # Do not allow a selected button to be de-selected.
          e.cancel = true if button.pressed()
      
      # Handle button press.
      button.pressed.onChanged (e) => 

            # Deselect the other toggle buttons.
            return unless button.canToggle()
            return if e.oldValue == true
            
            for btn in @togglable()
                if btn isnt button and btn.canToggle() and btn.pressed()
                    btn.pressed false
      
      # Finish up.
      button
      

  ###
  Removes all buttons from the set.
  @param options
            silent: supresses the 'remove' event (default false).
  ###
  clear: (options = {}) -> 
        
        # Setup initial conditions.
        options.silent ?= false
        # buttons = @buttons
        
        # Remove all items from the buttons collection.
        buttons = @buttons.select -> true
        for btn in buttons
            @buttons.remove btn, options
          
        # Alert listeners.
        @trigger('clear', source: @) unless options.silent

