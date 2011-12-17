core     = require 'open.client/core'
controls = require 'open.client/controls'


module.exports = class DummyView extends core.mvc.View
  defaults:
    color:  'red'  # Sets the color of the background (Values: 'red', 'green', 'orange).
    width:  null   # Gets or sets the pixel width of the control.
    height: null   # Gets or sets the pixel height of the control.
  
  constructor: (props = {}) -> 
    super _.extend props, className: 'test_dummy'
    
    # Controllers.
    new controls.controllers.Size @
    
    # Sycers.
    colorClass = (color) -> "bg_#{color}"
    syncColor = => @el.addClass colorClass(@color())
    
    # Wire up events.
    @color.onChanging (e) => @el.removeClass colorClass(e.oldValue)
    @color.onChanged -> syncColor()
    
    # Finish up.
    syncColor()
    
