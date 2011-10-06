SystemToggleSet = require './system_toggle_set'


###
A vertical or horizontal set of checkboxes.
###
module.exports = class CheckboxSet extends SystemToggleSet
  ButtonType: require './chk'
  
  constructor: (params) -> 
      super params
      @el.addClass @_className('checkbox_set')
