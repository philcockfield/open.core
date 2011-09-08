module.exports = (core, Button) -> 
  
  ###
  A 'command' style button.
  ###
  class CmdButton extends Button
    defaults:
        
        ###
        The size of the button (default 'm' - medium).
        Size options: s, m, l.
        ###
        size: 'm'
        
        ###
        The color of the button (default 'blue').
        Color options: silver, blue, green.
        ###
        color: 'silver'
    
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        self = @
        super _.extend params, tagName: 'button', className: 'core_cmd'
        @render()
        
        # Event handlers.
        toggleClass = (e, classPrefix) -> 
                  toggle = (value, toggle) -> 
                        self.el.toggleClass(classPrefix + value, toggle) if value?
                  toggle e.oldValue, false
                  toggle e.newValue, true

        onSizeChanged     = (e) -> toggleClass e, 'core_size_'
        onColorChanged    = (e) -> toggleClass e, 'core_color_'
        onSelectedChanged = (e) -> self.el.toggleClass 'active', e.newValue
        
        # Wire up events.
        @size.onChanged     onSizeChanged
        @color.onChanged    onColorChanged
        @selected.onChanged onSelectedChanged
        
        # Finish up.
        onSizeChanged     newValue: @size()
        onColorChanged    newValue: @color()
        onSelectedChanged newValue: @selected()
        
    
    render: -> 
      @html @label()
    



    