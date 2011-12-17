core = require 'open.client/core'

###
Manages displaying a popup view over a context object.
###

module.exports = class PopupController
  
  ###
  Constructor.
  @param context:   The [View], [Button], or jQuery element, that represents is the 
                    source context for the popup.
  @param popup:     The [View] or jQuery element that is to be displayed as the popup.
  ###
  constructor: (@context, @popup) -> 
    
    # Setup initial conditions.
    toJQuery = core.util.toJQuery
    
    # Extract jQuery elements.
    @elContext = toJQuery @context
    @elPopup   = toJQuery @popup
    
    # Hide the popup by default.
    
    
  
  
  ###
  Reveals the popup.
  ###
  show: -> 
  
  
  # Hides the popup.
  hide: -> 
  
  
    
  