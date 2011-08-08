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
      super params
      @addProps
          label:      params.label     ?= ''     # Gets or sets the text label for the button.
          canToggle:  params.canToggle ?= false  # Gets or sets whether the button can remain toggled in a down state.
          pressed:    params.pressed   ?= false  # Gets or sets whether the button is currently pressed (in a down state).
          over:       false                      # Gets whether the the mouse is currently over the button (written to internally only.)
      
      # Wire up events.
      @pressed.onChanged (e) => 
          @trigger('selected', source:@) if @canToggle() and @pressed()
      
      # Mouse events.
      @el.mouseover (e) => 
          @over true
          @_stateChanged()
      @el.mouseout (e) => 
          @over false
          @_stateChanged()
          
          # RESET MOUSE STATE - see mouse up.
          
      @el.mousedown (e) => 
          @_mouseDown = true
          @_wasPressed = @pressed()
          @pressed true
          @_stateChanged()
      
      @el.mouseup (e) => 
          
          @_mouseDown = false
          
          if @canToggle()
            @pressed not @_wasPressed
          else
            
            @pressed false 
          
          @click _toggle:false

  ###
  Indicates to the button that it has been clicked.
  This causes the 'click' event to fire and state values to be updated.
  @param options
          - silent : Flag indicating whether the click event should be suppressed (default false).
  @returns true if the click operation completed successfully, or false if it was cancelled.
  ###
  click: (options = {}) -> 
      # Setup initial conditions.
      options._toggle ?= true
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
          return false if preArgs.cancel is yes

      # Adjust the [pressed] state
      @toggle() if options._toggle

      # Alert listeners.
      @trigger('click', source: @) if fireEvent
      
      # Finish up.
      @_stateChanged()
      true


  ###
  Wires up the specified handler to the button's [click] event.
  @param handler : Function to invoke when the button is clicked.
  ###
  onClick: (handler) -> @bind('click', handler) if handler?

  ###
  Wires up the specified handler to the button's [selected] event.
  The is selected when:
    1. It can toggle, and
    2. It is pressed (down)
  @param handler : Function to invoke when the button is selected.
  ###
  onSelected: (handler) -> @bind('selected', handler) if handler?
  
  ###
  Toggles the pressed state (if the button can toggle).
  @returns true if the button was toggled, or false if the button cannot toggle.
  ###
  toggle: -> 
      return false if not @canToggle()
      @pressed(not @pressed())
    
  
  ###
  No-op. Invoked when the state of the button has changed (ie. via a mouse event)
  Override this to update visual state.
  See corresponding event: 'stateChanged'
  ###
  stateChanged: -> 

  ###
  PRIVATE MEMBERS
  ###
  _stateChanged: -> 
      @trigger 'stateChanged'
      @stateChanged()
      
      console.log 'over: ', @over(), ' | _mouseDown: ', @_mouseDown, ' | pressed: ', @pressed()
      


