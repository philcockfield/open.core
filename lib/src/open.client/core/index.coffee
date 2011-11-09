module.exports = core =
  title:      'Open.Core (Client)'
  
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
    
    # Attach sub-modules.
    core.Base       = require './base'
    core.util       = require './util'
    core.tryRequire = core.util.tryRequire
    core.mvc        = require './mvc'
    

  