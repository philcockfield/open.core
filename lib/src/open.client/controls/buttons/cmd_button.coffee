module.exports = (core, Button) -> 
  
  ###
  A 'command' style button.
  ###
  class CmdButton extends Button
    defaults:
        size: 'm'        # The size of the button (default 'm' - medium). Options: s, m, l.
        color: 'silver'  # The color of the button (default 'blue'). Options: silver, blue, green.
    
    
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        self = @
        super _.extend params, tagName: 'span', className: 'core_btn_cmd'
        @render()
        
        # Event handlers.
        toggleClass = (e, classPrefix) -> 
                  toggle = (value, toggle) -> 
                        self.el.toggleClass(classPrefix + value, toggle) if value?
                  toggle e.oldValue, false
                  toggle e.newValue, true

        onSizeChanged     = (e) -> toggleClass e, 'core_size_'
        onColorChanged    = (e) -> toggleClass e, 'core_color_'
        onSelectedChanged = (e) -> self._btn.toggleClass 'active', e.newValue
        
        # Wire up events.
        @size.onChanged     onSizeChanged
        @color.onChanged    onColorChanged
        @selected.onChanged onSelectedChanged
        @label.onChanged (e) => @_btn.text e.newValue
        
        # Finish up.
        onSizeChanged     newValue: @size()
        onColorChanged    newValue: @color()
        onSelectedChanged newValue: @selected()
    
    
    render: -> 
        @_btn = $("<button>#{@label()}</button>")
        @html @_btn

    