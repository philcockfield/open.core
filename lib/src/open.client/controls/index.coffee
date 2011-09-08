core = require 'open.client/core'
use = (name) -> require 'open.client/controls/' + name

Button    = use 'button'
ButtonSet = use 'button_set'

module.exports = 
  Textbox:    use 'textbox'
  
  # Buttons.
  Button:        Button
  ButtonSet:     ButtonSet
  CmdButton: use('buttons/cmd_button') core, Button
  
  