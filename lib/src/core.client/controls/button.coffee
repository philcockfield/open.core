core = require 'core.client/core'

###
A clickable button.
###
module.exports = class Button extends core.mvc.View
  ###
  Constructor.
  @param params : used to override default property values.
  ###
  constructor: (params = {}) -> 
      super params
      @addProps
          pressed:    params.pressed   ?= false  # Gets or sets whether the button is currently pressed (in a down state).
          canToggle:  params.canToggle ?= false  # Gets or sets whether the button can remain toggled in a down state.
          label:      params.label     ?= ''     # Gets or sets the text label for the button.
      
      # Wire up events.
      @pressed.onChanged (e) => 
          @trigger('selected', source:@) if @canToggle() and @pressed()
          

  ###
  Indicates to the button that it has been clicked.
  This causes the 'click' event to fire and state values to be updated.
  @param options
          - silent : Flag indicating whether the click event should be suppressed (default false).
  ###
  click: (options) -> 
      preArgs = 
          source: @
          cancel: false

      # Don't allow click is disabled.
      return if not @enabled()

      # Determine if event is required.
      fireEvent = not (options?.silent == true)

      # Fire the pre-click event.
      if (fireEvent)
          @trigger('pre:click', preArgs);

          # Check whether any listeners cancelled the click operation.
          return if preArgs.cancel is yes

      # Adjust the [pressed] state
      @pressed(not @pressed()) if @canToggle()

      # Alert listeners.
      @trigger('click', source: @) if fireEvent


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


