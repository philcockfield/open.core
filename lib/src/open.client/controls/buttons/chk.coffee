SystemStateButton = require './system_state'

###
Standard Checkbox with label.
###
module.exports = class Checkbox extends SystemStateButton
  constructor: (params) -> 
      super params
      @elInput = $ '<INPUT type="checkbox" />'
      @render()
