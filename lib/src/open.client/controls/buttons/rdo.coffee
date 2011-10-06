SystemToggleButton = require './system_toggle'

###
Standard Radio button with label.
###
module.exports = class RadioButton extends SystemToggleButton
  constructor: (params) -> 
      super params
      @el.addClass @_className 'radio'
      @elInput = $ '<INPUT type="radio" />'
      @render()
