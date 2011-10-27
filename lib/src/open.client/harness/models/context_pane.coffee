###
Logical representation the context-pane shown below the control host.
###
module.exports = (module) ->
  class ContextPane extends module.mvc.Model
    defaults:
        visible: false # Gets or sets the visibility of the pane.
    
    # Shows the pane by setting the [visible] property to true.
    show: -> @visible true
    
    # Hides the pane by setting the [visible] property to false.
    hide: -> @visible false
    
