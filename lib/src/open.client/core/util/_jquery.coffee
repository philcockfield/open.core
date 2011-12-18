
module.exports = 
  ###
  Attempts to convert the given [view/element/string] to a jQuery object.
  @param value : The value to convert.  This can be either a:
                  - jQuery object (returns same value)
                  - string (CSS selector)
                  - an MVC View (returns .el)
                  - HTMLElement (wraps in jQuery object)
  @returns a jQuery object, or null if the value was undefined/null.
  ###
  toJQuery: (value) ->
    # Setup initial conditions.
    return value if not value?
    
    # Check whether the object is already a jQuery object, or is an MVC [View].
    return value if (value instanceof jQuery) 
    return value.el if (value.el instanceof jQuery) 
    
    # Not a known type - wrap it as a jQuery object.
    return $(value)
  
  
  ###
  Reads the style value from the given element, and removes any non-digit
  characters, parsing it into a number.
  @param el:            The jQuery element to read.
  @param style:         The CSS style name to read.
  @param defaultResult: The value to return if there is no corresponding CSS value.
  ###
  cssNum: (el, style, defaultResult = 0) -> 
    # Setup initial conditions.
    return defaultResult unless el? and style?
    value = el.css style
    return defaultResult if value? is false or value is ''
    
    # Extract the number.
    value = value.replace /[^-\d\.]/g, ''
    value = parseFloat value
    
    # Finish up.
    value
  
  
  ###
  Updates the absolute position of the given element.
  @param el:      The element (or view) to update.
  @param top:     The top value (or null to not set).
  @param right:   The right value (or null to not set).
  @param bottom:  The bottom value (or null to not set).
  @param left:    The left value (or null to not set).
  @param unit:    Optional. The unit (default 'px').
  ###
  absPos: (el, top, right, bottom, left, unit = 'px') -> 
    el = @toJQuery el
    el.css 'position', 'absolute'
    set = (style, value) -> 
        value = if value? then value + unit else ''
        el.css style, value
    set 'top',    top
    set 'right',  right
    set 'bottom', bottom
    set 'left',   left


###
Source: http://stackoverflow.com/questions/2132172/disable-text-highlighting-on-double-click-in-jquery/2132230#2132230
Example - No text selection on elements with a class of 'noSelect':

    $('.noSelect').disableTextSelect()

###
$.extend $.fn.disableTextSelect = -> 
  return @.each -> 
    if $.browser.mozilla
      # Firefox.
      $(@).css 'MozUserSelect', 'none'
    else if $.browser.msie
      # Internet Explorer.
      $(@).bind 'selectstart', -> false
    else 
      # Opera and everything else.
      $(@).mousedown -> false
