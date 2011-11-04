core   = require '../../core'
Button = require '../button'

###
A 'command' style button.
###
module.exports = class CmdButton extends Button
    defaults:
        size: 'm'        # The size of the button (default 'm' - medium). Options: s, m, l.
        color: 'silver'  # The color of the button (default 'blue'). Options: silver, blue, green.
        width: null      # Number. The pixel width of the button.  Set to null for default offset width around the label.
    
    
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        self = @
        super _.extend params, tagName: 'span', className: @_className('btn_cmd')
        @render()

        # Syncers.
        
        # Event handlers.
        toggleClass = (e, classPrefix) -> 
                  toggle = (value, toggle) -> 
                        self.el.toggleClass(classPrefix + value, toggle) if value?
                  toggle e.oldValue, false
                  toggle e.newValue, true
        
        onSizeChanged     = (e) => toggleClass e, @_className('size_')
        onColorChanged    = (e) => toggleClass e, @_className('color_')
        onSelectedChanged = (e) => self._btn.toggleClass 'active', e.newValue
        onWidthChanged = (e) =>  
            width = e.newValue
            if width? 
              width += 'px' 
            else
              width = 'auto'
            @el.css 'width', width
        
        # Wire up events.
        @size.onChanged     onSizeChanged
        @color.onChanged    onColorChanged
        @selected.onChanged onSelectedChanged
        @width.onChanged    onWidthChanged
        @width.onReading (e) => 
            width   = core.util.jQuery.cssNum @el, 'width'
            width   = null if width is 0
            e.value = width
            
        @label.onChanged (e) => @_btn.text e.newValue
        
        # Finish up.
        onSizeChanged     newValue: @size()
        onColorChanged    newValue: @color()
        onSelectedChanged newValue: @selected()
        onWidthChanged    newValue: params.width ? null
    
    
    render: -> 
        @_btn = $("<button>#{@label()}</button>")
        @html @_btn

    