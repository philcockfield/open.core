Button = require '../button'

###
Base class for Radio Buttons and Checkboxes.
###
module.exports = class SystemToggleButton extends Button
  constructor: (params = {}) -> 
      super _.extend params, canToggle: true, tagName: 'span'
      @el.addClass @_className('system_toggle_btn')
      @el.disableTextSelect() # Prevent text selection from double-click.
  
  
  # Renders to the DOM.
  render: -> 
      className = @_className 'label'
      @elLabel = $("<span class=\"#{className}\">#{@label()}</span>")
      @el.append @elInput
      @el.append @elLabel
      syncInput @
  
  
  # Gets the INPUT element.
  elInput: undefined # Set HTML element in constructor of overriding class.
  
  
  ###
  Updates the checked state of the INPUT element.  
  Override if using a non-standard INPUT element that does not respond to this jQuery call.
  @param checked : Flag indicating the checked state to apply.
  ###
  isChecked: (checked) -> @elInput?.attr('checked', checked)
  
  
  # Overridden methods.
  handleSelectedChanged: (args) -> syncInput @
  

# PRIVATE STATIC --------------------------------------------------------------------------


syncInput = (view) -> view.isChecked view.selected()


    