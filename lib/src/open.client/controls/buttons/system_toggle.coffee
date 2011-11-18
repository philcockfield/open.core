Button = require '../button'


###
Base class for Radio Buttons and Checkboxes.
###
module.exports = class SystemToggleButton extends Button
  constructor: (params = {}) -> 
      super _.extend params, canToggle: true, tagName: 'span'
      @el.addClass @_className('system_toggle_btn')
      @el.disableTextSelect() # Prevent text selection occuring from double-click.
  
  
  # Renders to the DOM.
  render: -> 
      
      # Insert INPUT element.
      @el.append @elInput
      
      # Insert label.
      labelClass = @_className 'label'
      @elLabel = $("<span class=\"#{labelClass}\">#{@label()}</span>")
      @el.append @elLabel
      
      # Finish up.
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
  handleSelectedChanged: (args) -> 
        
        # Determine if a click on sub-INPUT element (not the parent Button) caused the state change.
        inputClicked = false
        srcElement = args.srcElement
        
        if srcElement?
            el = srcElement.get(0)
            inputClicked = srcElement.get(0) is @elInput.get(0)
            
        
        # Sync the INPUT element only if the state-change was not caused by a click event 
        # on that element (if it was because of a click it will already be in the correct state).
        syncInput @ if inputClicked is false


# PRIVATE STATIC --------------------------------------------------------------------------


syncInput = (view) -> view.checked view.selected()


    