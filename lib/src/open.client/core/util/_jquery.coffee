
module.exports = 
  
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
