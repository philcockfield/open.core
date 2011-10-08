core = require '../core'

###
A click-able button.
Events:
  - selected
  - pre:click
  - click
  - stateChanged
###
module.exports = class Button extends core.mvc.View
  ###
  Constructor.
  @param params : default property values.
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
          value:      null                       # Gets or sets a value to associate with the button. This is useful for things like RadioButtons and Checkboxes.
      
      # Wire up events.
      @selected.onChanged (e) => 
          
          isSelected = self.selected()
          
          # TODO Tests for these args.
          args = 
              source:     self
              selected:   isSelected
              srcElement: e.options.srcElement
              
          self._stateChanged('selected')
          self.handleSelectedChanged args
          self.trigger('selected', args) if self.canToggle() and isSelected
      
      # Mouse events.
      do -> 
          el = self.el
          stateChanged = (e, event) -> 
                          srcElement = core.util.toJQuery(e.srcElement)
                          self._stateChanged event, srcElement: srcElement
          
          el.mouseenter (e) => 
              self.over true
              stateChanged e, 'mouseenter'
          
          el.mouseleave (e) => 
              self.over false
              #  Reset down state (in case the mouse went out of scope but the button was not released).
              self.down false
              stateChanged e, 'mouseleave'
          
          el.mousedown (e) => 
              self.down true
              stateChanged e, 'mousedown'
          
          el.mouseup (e) => 
              self.down false
              # Passes through to state-changed via the [click] method.
              self.click srcElement: e.srcElement
      
      # Finish up.
      syncClasses @
  
  
  ###
  Indicates to the button that it has been clicked.
  This causes the 'click' event to fire and state values to be updated.
  
  @param options
          - silent :    (optional) Flag indicating whether the click event should be suppressed (default false).
          - srcElement: (optional) The source element that caused the event to fire.
                                   This is useful when sub-elements within the button (eg. something like an embedded checkbox)
                                   cause the event to fire.  This value is passed as an argument in the [click] event.
          
  @returns true if the click operation completed successfully, or false if it was cancelled.
  ###
  click: (options = {}) =>
      # Setup initial conditions.
      srcElement = options.srcElement ?= @el
      srcElement = core.util.toJQuery srcElement
      preArgs = 
          source:     @
          cancel:     false
          srcElement: srcElement
      
      # Don't allow click is disabled.
      return if not @enabled()
      
      # Determine if event is required.
      fireEvent = not (options.silent == true)
      
      # Fire the pre-click event.
      if (fireEvent)
          @trigger('pre:click', preArgs);
          
          # Check whether any listeners cancelled the click operation.
          if preArgs.cancel is yes
              @_stateChanged('click:cancelled')
              return false 
      
      # Adjust the [selected] state
      @toggle srcElement:srcElement
      
      # Alert listeners.
      if fireEvent
        @trigger('click', source: @, srcElement:srcElement)
      
      # Finish up.
      @_stateChanged('click', srcElement:srcElement)
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
  @param options
            - srcElement : (optional). Used internally to pass event args from mouse events.
  @returns true if the button was toggled, or false if the button cannot toggle.
  ###
  toggle: (options = {}) => 
      return false if not @canToggle()
      @selected(not @selected(), options)
      true
  
  
  ###
  Invoked when the state of the button has changed (ie. via a mouse event)
  Override this to update visual state.
  See corresponding event: 'stateChanged'
  @param args: 
          - state:    String indicating what state caused the change.
  ###
  handleStateChanged: (args) => # No-op.
  
  
  ###
  Invoked when the selection has changed.
  Override this to update visual state.
  See corresponding event: 'selected'
  @param args: 
          - selected:  Flag indicating if the button is currenlty selected.
  ###
  handleSelectedChanged: (args) -> # No-op.
  
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  _stateChanged: (state, options = {}) => 
      # Update button state.
      syncClasses @
      
      # Alert listeners.
      args = 
          source:     @
          state:      state
          srcElement: options.srcElement
      @handleStateChanged args
      @trigger 'stateChanged', args


# PRIVATE STATIC --------------------------------------------------------------------------


syncClasses = (view) -> 
    toggle = (name, fn) => view.el.toggleClass view._className(name), fn()
    toggle 'selected', view.selected
    toggle 'over',     view.over
    toggle 'down',     view.down

