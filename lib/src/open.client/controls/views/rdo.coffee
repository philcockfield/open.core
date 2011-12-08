###
Standard Radio button with label.
###
module.exports = (module) ->
  SystemToggleButton = module.view 'system_toggle'
  
  class RadioButton extends SystemToggleButton
    constructor: (params) -> 
        super params
        @el.addClass @_className 'radio'
        @elInput = $ '<INPUT type="radio" />'
        @render()
