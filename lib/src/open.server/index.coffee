module.exports = server =
  title:       'Open.Core (Server)'
  
  # Set in bootstrap below.
  paths:       undefined 
  util:        undefined
  client:      undefined
  configure:   undefined
  
  
  ###
  Generates the standard copyright notice (MIT).
  @param options (optional)
          - asComment: Flag indicating if the copyright notice should be within an HTML comment.
  ###
  copyright: (options = {}) ->
      notice = "Copyright #{new Date().getFullYear()} Phil Cockfield. All rights reserved."
      if options.asComment
                notice = """
                /*
                  #{notice}
                  The MIT License (MIT)
                  https://github.com/philcockfield/open.core
                */
                """
      notice


# Bootstrap.
do -> 
    
    # Initialize 3rd party libs.
    require './config/libs'
    
    # Store sub-modules.
    # NB: Set here to avoid load order problems with sub-modules that
    #     in turn require the [server] module.
    server.paths           = require './config/paths'
    server.util            = require './util'
    server.client          = require 'open.client'
    server.configure       = require './config/configure'
    
    # Test runners.
    server.configure.specs   = require './routes/test/jasmine'
    server.configure.harness = require './routes/test/harness'


