ControlList = require './control_list'
Checkbox    = require './chk'


###
A vertical or horizontal set of checkboxes.
###
module.exports = class CheckboxSet extends ControlList
  ButtonType: Checkbox
  
  constructor: (params) -> 
    super params
    @el.addClass @_className('checkbox_set')
  
  
  ###
  Adds a new Button to the collection.
  The button is created using the type specified within the [ButtonType] property.
  @param options : The options to pass to the Button's constructor.
  @returns the newly created Button.
  ###
  add: (options = {}) -> btn = super new @ButtonType options
