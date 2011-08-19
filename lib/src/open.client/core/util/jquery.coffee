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
