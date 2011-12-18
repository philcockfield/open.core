core   = require 'open.client/core'
util   = core.util
Button = null
elMask = null

MAX = 2147483647


###
Manages displaying a popup view over a context object.
###
module.exports = class PopupController
  ###
  Constructor.
  @param context:   The [View], [Button], or jQuery element, that represents is the 
                    source context for the popup.
  @param fnPopup:   Function that produces the [View] or jQuery that is the Popup
                    to be displayed as the popup when the context is clicked.
  @param options:
          - cssPrefix:  The CSS prefix to use (default 'core_')
          - clickable:  Flag indicating if the popup should be displayed when
                        the [content] is clicked (default true).
  ###
  constructor: (@context, @fnPopup, @options = {}) -> 
    
    # Setup initial conditions.
    Button ?= require '../views/button' # NB: Required here so that the proper singleton instance is used.
    
    toJQuery  = core.util.toJQuery
    options   = @options
    context   = @context
    popup     = @popup
    
    options.cssPrefix ?= 'core_'
    options.clickable ?= true
    
    # Extract jQuery elements.
    @elContext = elContext = toJQuery context
    
    # Wire up events.
    if options.clickable is yes
      if (context instanceof Button)
        context.onClick => @show()
      else
        elContext.click => 
          return if context.enabled? and context.enabled() is no
          @show() 
  
  
  ###
  Reveals the popup.
  ###
  show: -> 
    body = $ 'body'
    
    # Get and display the screen mask.
    mask = do => 
      return elMask if elMask?
      
      # Create and insert the mask.
      elMask = $ "<div class='#{@options.cssPrefix}popup_mask'></div>"
      body.append elMask
      
      # Wire up events.
      elMask.click => @hide()
      
      # Finish up.
      elMask
    mask.toggle true
    
    # Create and insert the popup.
    popup   = @fnPopup()
    elPopup = core.util.toJQuery popup
    elPopup.css 'z-index', MAX
    elPopup.css 'position', 'absolute'
    body.append elPopup
    
    
    # Finish up.
    @elPopup = elPopup
    
    
    
    
  
  
  ###
  Hides the popup.
  ###
  hide: -> 
    
    #  Remove the popup.
    @elPopup.remove()
    delete @elPopup
    
    # Hide the screen mask.
    elMask?.toggle false
    
    console.log 'hide'
    
  
  
# PRIVATE --------------------------------------------------------------------------


mask = -> 
  return elMask if elMask?
  
  elMask = $ 'div '
  
  


  
  