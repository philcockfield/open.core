SystemToggleSet = require './system_toggle_set'


###
A vertical or horizontal set of radio buttons.
###
module.exports = class RadioButtonSet extends SystemToggleSet
  ButtonType: require './rdo'
  
  constructor: (params) -> 
      super params
      @el.addClass @_className('radio_set')
