core = require 'open.client/core'
use = (name) -> require 'open.client/controls/' + name

Button    = use 'button'
ButtonSet = use 'button_set'

module.exports = 
  Textbox:    use 'textbox'
  
  # Buttons.
  Button:        Button
  ButtonSet:     ButtonSet
  CommandButton: use('buttons/command_button') core, Button
  
  