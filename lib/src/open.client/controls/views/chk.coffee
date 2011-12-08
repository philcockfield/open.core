###
Standard Checkbox with label.
###
module.exports = (module) ->
  SystemToggleButton = module.view 'system_toggle'
  
  class Checkbox extends SystemToggleButton
    constructor: (params) -> 
        super params
        @el.addClass @_className 'checkbox'
        @elInput = $ '<INPUT type="checkbox" />'
        @render()
