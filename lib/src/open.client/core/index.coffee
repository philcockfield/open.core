util       = require './util'
tryRequire = util.tryRequire

module.exports = core =
  title:      'Open.Core (Client)'

  Base:       require './base'
  mvc:        require './mvc'

  util:       util
  tryRequire: tryRequire
  
  ###
  Initializes [Open.Core]
  This ensures all parts of the library that are included in the page
  are attached to this root index.
  ###
  init: -> 
    req = (name) -> 
              try
                require name
              catch error
                # Ignore - not included in page
    
    @controls = require '../controls'
    
    
  