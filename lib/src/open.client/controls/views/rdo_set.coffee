###
A vertical or horizontal set of radio buttons.
###
module.exports = (module) ->
  SystemToggleSet = module.view 'system_toggle_set'
  RadioButton     = module.view 'rdo'
  
  class RadioButtonSet extends SystemToggleSet
    ButtonType: RadioButton
    
    constructor: (params) -> 
        super params
        @el.addClass @_className('radio_set')
