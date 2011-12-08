module.exports = (module) ->
  view = (name) -> module.view name
  
  index =
    Textbox:         view 'textbox'
    ControlList:     view 'control_list'
    TabStrip:        view 'tab_strip'
    Form:            view 'form'
    ComboBox:        view 'combo_box'
    
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
    
    # 
    # index.Button          = view 'button'
    # index.ButtonSet       = view 'button_set'
    # index.ControlList     = view 'control_list'
    # 
    # index.Textbox         = view 'textbox'
    # index.TabStrip        = view 'tab_strip'
    # index.Form            = view 'form'
    # index.ComboBox        = view 'combo_box'
    # 
    # # Buttons.
    # index.CmdButton       = view 'cmd'
    # 
    # index.SystemToggle    = view 'system_toggle'
    # index.SystemToggleSet = view 'system_toggle_set'
    # 
    # index.Checkbox        = view 'chk'
    # index.CheckboxSet     = view 'chk_set'
    # index.RadioButton     = view 'rdo'
    # index.RadioButtonSet  = view 'rdo_set'
    # 
    # index
    # 