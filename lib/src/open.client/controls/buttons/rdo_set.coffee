core        = require '../../core'
ButtonSet   = require '../button_set'
RadioButton = require './rdo'

module.exports = class RadioButtonSet extends core.mvc.View
  RadioButton: RadioButton
  
  constructor: () -> 
      super tagName: 'ul', className: @_className('radio_set')
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
  
