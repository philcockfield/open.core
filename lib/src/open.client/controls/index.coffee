button = (name) -> require './buttons/' + name

module.exports = 
  Textbox:         require './textbox'
  ControlList:     require './control_list'
  TabStrip:        require './tab_strip'
  Form:            require './form'
  ComboBox:        require './combo_box'
  
  # Buttons.
  Button:          require './button'
  ButtonSet:       require './button_set'
  
  CmdButton:       button 'cmd'
  Checkbox:        button 'chk'
  CheckboxSet:     button 'chk_set'
  RadioButton:     button 'rdo'
  RadioButtonSet:  button 'rdo_set'
  SystemToggle:    button 'system_toggle'
  SystemToggleSet: button 'system_toggle_set'
  