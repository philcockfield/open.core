view = (name) -> require './' + name


module.exports = 
  ControlList:     view 'control_list'
  TabStrip:        view 'tab_strip'
  ComboBox:        view 'combo_box'
  Textbox:         view 'textbox'
  Popup:           view 'popup'
  
  # Buttons.
  Button:          view 'button'
  ButtonSet:       view 'button_set'
  CmdButton:       view 'cmd'
  Checkbox:        view 'chk'
  CheckboxSet:     view 'chk_set'
  RadioButton:     view 'rdo'
  RadioButtonSet:  view 'rdo_set'
  SystemToggle:    view 'system_toggle'
  SystemToggleSet: view 'system_toggle_set'
  Icon:            view 'icon'

