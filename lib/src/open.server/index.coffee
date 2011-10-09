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
    server.paths           = require './config/paths'
    server.util            = require './util'
    server.client          = require 'open.client'
    server.configure       = require './config/configure'
    server.configure.specs = require './routes/specs'


