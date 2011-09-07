module.exports = (core, Button) -> 
  
  ###
  A 'command' style button.
  ###
  class CommandButton extends Button
    defaults:
        
        ###
        Gets or sets the size of the button (default 'm' - medium).
        Size options are: s, m, l.
        ###
        size: null
    
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        super _.extend params, tagName: 'button', className: 'core_cmd'
        @render()
        
        # Wire up events.
        @size.onChanged (e) =>
              # Update the CSS class that defines the size of the button.
              toggle = (size, toggle) => 
                    @el.toggleClass('core_size_' + size, toggle) if size?
              toggle e.oldValue, false
              toggle e.newValue, true
        
        # Set default values.
        @size params.size ?= 'm'
        
    
    render: -> 
      @html @label()
    



    