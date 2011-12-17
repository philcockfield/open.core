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
    
    
    
  