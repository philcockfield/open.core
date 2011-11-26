module.exports = server =
  title:       'Open.Core (Server)'
  
  # Set in bootstrap below.
  paths:       undefined 
  util:        undefined
  log:         undefined
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
  
  
  ###
  Starts the development server.
  @param options
            - port: (optional) The port to start the server on (default 8080).
  ###
  start: (options = {})->
    # Setup initial conditions.
    @configure null, 
      baseUrl: '/', 
      callback: => 
        app  = @app
        log  = @util.log
    
        # Determine which port to start on.
        options.port ?= 8080
        port = process.env.PORT ?= options.port

        # Start listening on requested port.
        app.listen port, =>
            log ''
            log 'Started: ', color.green, "#{@title} listening on port #{app.address().port} in #{app.settings.env} mode"
            log '---', color.green



# Bootstrap.
do -> 
    
    # Initialize 3rd party libs.
    require './config/libs'
    
    # Store sub-modules.
    # NB: Set here to avoid load order problems with sub-modules that
    #     in turn require the [server] module.
    server.paths       = require './config/paths'
    
    server.client      = require 'open.client'
    server.version     = server.client.core.version
    server.mvc         = server.client.core.mvc
    
    server.util        = require './util'
    server.log         = server.util.log
    server.configure   = require './config/configure'
    server.modules     = require './modules'
    
    # Test runners.
    server.configure.specs   = require './routes/testing/jasmine'
    server.configure.harness = require './routes/testing/harness'


