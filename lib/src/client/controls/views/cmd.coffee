core            = require 'open.client/core'
FocusController = require '../controllers/focus'
Button          = require './button'



###
A 'command' style button.
###
module.exports = class CmdButton extends Button
  defaults:
    size:       'm'       # The size of the button (default 'm' - medium). Options: s, m, l.
    color:      'silver'  # The color of the button (default 'silver'). Options: silver, blue, green.
    width:      null      # Number. The pixel width of the button.  Set to null for default offset width around the label.
    labelOnly:  false     # Flag indicating whether the background should be hidden (showing only the label) in it's 'normal' state.
  
  
  constructor: (params = {}) -> 
    # Setup initial conditions.
    self = @
    super _.extend params, tagName: 'span', className: @_className('btn_cmd')
    @render()
    
    # Event handlers.
    toggleClass = (e, classPrefix) -> 
              toggle = (value, toggle) -> 
                    self.el.toggleClass(classPrefix + value, toggle) if value?
              toggle e.oldValue, false
              toggle e.newValue, true
    
    onSizeChanged      = (e) => toggleClass e, @_className('size_')
    onColorChanged     = (e) => toggleClass e, @_className('color_')
    onSelectedChanged  = (e) => self._btn.toggleClass 'active', e.newValue
    onLabelOnlyChanged = (e) => 
      @el.toggleClass @_className('label_only'), e.newValue
      @update()
    onWidthChanged = (e) =>  
      width = e.newValue
      if width? 
        width += 'px' 
      else
        width = 'auto'
      @el.css 'width', width
    
    
    # Create controllers.
    focus = new FocusController @, @_btn, => @update()
    
    
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
    @labelOnly.onChanged onLabelOnlyChanged
    
    # Finish up.
    onSizeChanged       newValue: @size()
    onColorChanged      newValue: @color()
    onSelectedChanged   newValue: @selected()
    onWidthChanged      newValue: params.width ? null
    onLabelOnlyChanged  newValue: @labelOnly()
  
  
  render: -> 
    @_btn = $("<button>#{@label()}</button>")
    @html @_btn
  
  
  ###
  Applies focus to the button.
  ###
  focus: undefined # Assigned by the focus controller.
    
  



