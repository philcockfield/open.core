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
  @returns True if the INPUT element is checked, otherwise False.
  ###
  checked: (checked) -> 
        return unless @elInput?
        
        # Write value.
        if checked?
            @elInput.attr('checked', checked)
        
        # Read value.
        value = @elInput.attr 'checked'
        if value is 'checked' then true else false
  
  
  # Overridden methods.
  handleSelectedChanged: (args) -> syncInput @
  

# PRIVATE STATIC --------------------------------------------------------------------------


syncInput = (view) -> view.checked view.selected()


    