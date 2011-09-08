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
        size: 'm'
    
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        self = @
        super _.extend params, tagName: 'button', className: 'core_cmd'
        @render()
        
        # Event handlers.
        onSizeChanged = (e) -> 
              # Update the CSS class that defines the size of the button.
              toggle = (size, toggle) -> 
                    self.el.toggleClass('core_size_' + size, toggle) if size?
              toggle e.oldValue, false
              toggle e.newValue, true
        
        onSelectedChanged = (e) -> self.el.toggleClass 'active', e.newValue
        
        # Wire up events.
        @size.onChanged     onSizeChanged
        @selected.onChanged onSelectedChanged
        
        # Finish up.
        onSizeChanged     newValue:@size(), oldValue:null
        onSelectedChanged newValue:@selected()
    
    render: -> 
      @html @label()
    



    