###
Handles updating the focus behavior of a control.
###
module.exports = class FocusController
  constructor: (view, element) -> 
    
    # Syncers.
    syncFocus = (hasFocus) => 
      view.el.toggleClass view._className('focused'), hasFocus
    
    # Wire up events.
    element.focusin => syncFocus(true)
    element.focusout => syncFocus(false)
    
    # Assign a focus method to the view 
    # (if there isn't an explicit one assigned).
    unless view.focus?
      view.focus = -> element.focus()
    
    
    
