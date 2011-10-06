SystemStateButton = require './system_state'

###
Standard Checkbox with label.
###
module.exports = class Checkbox extends SystemStateButton
  constructor: (params) -> 
      super params
      @el.addClass @_className 'checkbox'
      @elInput = $ '<INPUT type="checkbox" />'
      @render()
