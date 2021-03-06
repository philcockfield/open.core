SystemToggleSet = require './system_toggle_set'
RadioButton     = require './rdo'

###
A vertical or horizontal set of radio buttons.
###
module.exports = class RadioButtonSet extends SystemToggleSet
  ButtonType: RadioButton
  
  constructor: (params) -> 
    super params
    @el.addClass @_className('radio_set')
