Button = require '../button'

###
Base class for Radio Buttons and Checkboxes.
###
module.exports = class SystemStateButton extends Button
  constructor: (params = {}) -> 
      super _.extend params, canToggle: true, tagName: 'span'
      @el.addClass "#{@_css_prefix}_system_state_btn"
      @el.disableTextSelect() # Prevent text selection from double-click.
  
  
  # Renders to the DOM.
  render: -> 
      cssClass = "#{@_css_prefix}_label"
      @elLabel = $("<span class=\"#{cssClass}\">#{@label()}</span>")
      @el.append @elInput
      @el.append @elLabel
  
  
  # Gets the INPUT element.
  elInput: undefined # Set HTML element in constructor of overriding class.
  
  
  # Updates the checked state of the INPUT element.  
  # Override if using a non-standard INPUT element that does not respond to this jQuery call.
  inputChecked: (selected) -> @elInput?.attr('checked', selected)
  
  
  # Overridden methods.
  handleSelectedChanged: (args) -> @_syncInput()
  
  # Private methods.
  _syncInput: -> @inputChecked @selected()
      
      
    