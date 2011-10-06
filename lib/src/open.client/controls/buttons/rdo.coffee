SystemStateButton = require './system_state'

###
Standard Radio button with label.
###
module.exports = class RadioButton extends SystemStateButton
  constructor: (params) -> 
      super params
      @elInput = $ '<INPUT type="radio" />'
      @render()
