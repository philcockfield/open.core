###
The core library.

Events:
   - window:resize   - Fires a single debounced event after a window resize operation.

###

module.exports = core =
  title:   'Open.Core (Client)'
  version: '0.1.187'
  
  ###
  Initializes [Open.Core]
  This ensures all parts of the library that are included in the page
  are attached to this root index.
  ###
  init: -> 
    @controls = @tryRequire 'open.client/controls'


# PRIVATE --------------------------------------------------------------------------


# Bootstrap.
do -> 
    
    # Setup initial conditions.
    _.extend core, Backbone.Events
    
    # Attach sub-modules.
    core.Base       = require './base'
    core.util       = require './util'
    core.tryRequire = core.util.tryRequire
    core.mvc        = require './mvc'
    
    # Wire up events.
    if window?
      $(window).resize _.debounce (-> core.trigger 'window:resize'), 100
    

  