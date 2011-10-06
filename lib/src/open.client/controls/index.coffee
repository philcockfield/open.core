button = (name) -> require './buttons/' + name

module.exports = 
  Textbox:    require './textbox'
  
  # Buttons.
  Button:         require './button'
  ButtonSet:      require './button_set'
  CmdButton:      button 'cmd_button'
  Checkbox:       button 'chk'
  RadioButton:    button 'rdo'
  RadioButtonSet: button 'rdo_set'
  
  