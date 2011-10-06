SystemToggleButton = require './system_toggle'

###
Standard Checkbox with label.
###
module.exports = class Checkbox extends SystemToggleButton
  constructor: (params) -> 
      super params
      @el.addClass @_className 'checkbox'
      @elInput = $ '<INPUT type="checkbox" />'
      @render()
