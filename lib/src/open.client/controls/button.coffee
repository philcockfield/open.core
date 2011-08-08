core = require 'open.client/core'

###
A click-able button.
###
module.exports = class Button extends core.mvc.View
  ###
  Constructor.
  @param params : used to override default property values.
  ###
  constructor: (params = {}) -> 
      self = @
      super params
      @addProps
          label:      params.label     ?= ''     # Gets or sets the text label for the button.
          canToggle:  params.canToggle ?= false  # Gets or sets whether the button can remain toggled in a down state.
          selected:   params.selected  ?= false  # Gets or sets whether the toggle button is currently selected (checked state.  Only applicable when canToggle).
          over:       false                      # Gets whether the the mouse is currently over the button (Read-only.  Written to internally.)
          down:       false                      # Gets whether the button is currently in a depressed state (Read-only.  Written to internally.)
      
      # Wire up events.
      @selected.onChanged (e) => 
          @_stateChanged()
          @trigger('selected', source:@) if @canToggle() and @selected()
      
      # Mouse events.
      do -> 
        el = self.el
        stateChanged = self._stateChanged
        
        el.mouseover (e) => 
            self.over true
            stateChanged()

        el.mouseout (e) => 
            self.over false
            #  Reset down state (in case the mouse went out of scope but the button was not released).
            self.down false
            stateChanged()
          
        el.mousedown (e) => 
            self.down true
            stateChanged()
      
        el.mouseup (e) => 
            self.down false
            self.click()

  ###
  Indicates to the button that it has been clicked.
  This causes the 'click' event to fire and state values to be updated.
  @param options
          - silent : Flag indicating whether the click event should be suppressed (default false).
  @returns true if the click operation completed successfully, or false if it was cancelled.
  ###
  click: (options = {}) =>
      # Setup initial conditions.
      preArgs = 
          source: @
          cancel: false

      # Don't allow click is disabled.
      return if not @enabled()

      # Determine if event is required.
      fireEvent = not (options.silent == true)
      
      # Fire the pre-click event.
      if (fireEvent)
          @trigger('pre:click', preArgs);

          # Check whether any listeners cancelled the click operation.
          if preArgs.cancel is yes
              @_stateChanged()
              return false 

      # Adjust the [selected] state
      @toggle() 

      # Alert listeners.
      @trigger('click', source: @) if fireEvent
      
      # Finish up.
      @_stateChanged()
      true

  ###
  Wires up the specified handler to the button's [click] event.
  @param handler : Function to invoke when the button is clicked.
  ###
  onClick: (handler) => @bind('click', handler) if handler?

  ###
  Wires up the specified handler to the button's [selected] event.
  The is selected when:
    1. It can toggle, and
    2. It is selected (down)
  @param handler : Function to invoke when the button is selected.
  ###
  onSelected: (handler) => @bind('selected', handler) if handler?
  
  ###
  Toggles the selected state (if the button can toggle).
  @returns true if the button was toggled, or false if the button cannot toggle.
  ###
  toggle: => 
      return false if not @canToggle()
      @selected(not @selected())
    
  
  ###
  No-op. Invoked when the state of the button has changed (ie. via a mouse event)
  Override this to update visual state.
  See corresponding event: 'stateChanged'
  ###
  stateChanged: => 

  ###
  PRIVATE MEMBERS
  ###
  _stateChanged: => 
      @trigger 'stateChanged'
      @stateChanged()
      


