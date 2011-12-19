core   = require 'open.client/core'
Button = require './button'


###
A button that presents an icon and optionally a text label.
###
module.exports = class Icon extends Button
  defaults:
    iconSize:     { x:16, y:16 }  # Gets or sets the pixel size of the icon (this may be larger than the actual image used - which will be centered).
    iconOffset:   { x:0, y:0 }    # Gets or sets the X:Y pixel offset to apply the icon.
    icon:         null            # Gets or sets the source of the icon (either a URL or a CSS class for embedded images).
    iconType:    'url'            # Gets or sets the type of value for icons ('css' or 'url').
    labelOffset:  { x:5, y:1 }    # Gets or sets the X:Y pixel offset to apply to the label.
    tooltip:     null             # Gets or sets the tooltip.
  
  
  constructor: (props = {}) -> 
    # Setup initial conditions.
    super _.extend props, tagName:'span', className:@_className 'icon_button'
    @render()
    @el.disableTextSelect()
    
    # Wire up events.
    @label.onChanged        => syncText @
    @tooltip.onChanged      => syncText @
    @icon.onChanged         => syncIcon @
    @iconType.onChanged     => syncIcon @
    @iconSize.onChanged     => syncSize @
    @iconOffset.onChanged   => syncSize @
    @labelOffset.onChanged  => syncSize @
    
    # Finish up.
    @update()
  
  
  render: -> 
    # Insert base HTML.
    @html new Tmpl().root(prefix:@_cssPrefix)
    
    # Retrieve element refs.
    el = (className) => @$ '.' + @_className(className)
    @_label = el 'label'
    @_icon  = el 'left_icon'
    @_carat = el 'carat'
  
  
  # Updates the visual state of the control.
  update: -> 
    syncText @
    syncSize @
    syncIcon @


# PRIVATE --------------------------------------------------------------------------


css = (el, style, pixelValue) -> el.css style, pixelValue + 'px'


syncText = (view) -> 
  view._label.html view.label()
  view.el.attr 'title', (view.tooltip() ? '')


syncSize = (view) -> 
  # Setup initial conditions.
  iconSize     = view.iconSize()
  iconOffset   = view.iconOffset()
  labelOffset  = view.labelOffset()
  elLabel      = view._label
  elIcon       = view._icon
  
  # Update label styles.
  css elLabel, 'margin-left', iconSize.x + labelOffset.x
  css elLabel, 'margin-top', labelOffset.y
  
  # Height.
  css view.el, 'min-height', iconSize.y
  
  # Icon offset.
  css elIcon, 'left', iconOffset.x 
  css elIcon, 'top', iconOffset.y


syncIcon = (view) -> 
  el   = view._icon
  icon = view.icon()
  el.attr 'class', view._className('left_icon') # Reset CSS class.
  
  bg = (url) -> 
    url = if url? then "url(#{url})" else null
    el.css 'background-image', url
  
  switch view.iconType()
    when 'url' then bg icon
    when 'css' then el.addClass icon
    else return


class Tmpl extends core.mvc.Template
  root:
    """
    <div class='<%= prefix %>_left_icon'></div>
    <p class="<%= prefix %>_label">Label</p>
    """
