ButtonSet   = require '../button_set'
ControlList = require '../control_list'
RadioButton = require './rdo'

###
A vertical or horizontal set of radio buttons.
###
module.exports = class RadioButtonSet extends ControlList
  
  # The type of RadioButton.  Override this in deriving class to use different RadioButtons in the set.
  RadioButton: RadioButton
  
  constructor: -> 
      super tagName: 'ul'
      @el.addClass @_className('radio_set')
      @buttons = new ButtonSet()
  
  
  ###
  Adds a Radio Button to the collection.
  @param options : The standard options used to construct a Radio Button
  @returns the new Radio Button.
  ###
  add: (options = {}) -> 
      
      # Create the radio button.
      rdo = new @RadioButton options
      @buttons.add rdo
      
      # Prepare for DOM.
      li = $('<li></li>')
      li.append rdo.el
      @el.append li
      
      # Finish up.
      rdo
  
