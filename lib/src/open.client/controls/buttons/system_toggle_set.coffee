ButtonSet   = require '../button_set'
ControlList = require '../control_list'

SELECTION_CHANGED = 'selectionChanged'

###
A vertical or horizontal set of buttons.

Events:
  - selectionChanged  : Fires when the selectin changes (does not fire on multiple clicks to the selected button).
                        Bubbled from the [buttons] property.

###
module.exports = class SystemToggleButtonSet extends ControlList
  
  # The type of Button to construct within the [add] method.  
  # Override this in deriving class to use different types of button in the set.
  ButtonType: undefined
  
  constructor: -> 
      
      # Setup initial conditions.
      super
      @buttons = new ButtonSet()
      
      # Wire up events.
      @buttons.bind SELECTION_CHANGED, (e) => @trigger SELECTION_CHANGED, e
  
  
  ###
  Retrieves the currently selected toggle-button.
  (passes through to the [selected] method on the [buttons] collection).
  ###
  selected: -> @buttons.selected()
  
  
  ###
  Adds a new Button to the collection.
  The button is created using the type specified within the [ButtonType] property.
  @param options : The options to pass to the Button's constructor.
  @returns the newly created Button.
  ###
  add: (options = {}) -> 
      btn = super new @ButtonType options
      @buttons.add btn
      btn
  
