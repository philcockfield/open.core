module.exports = core =
  title:       'Open.Core (Server)'
  
  
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
    @init null, 
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
            log 'Started: ', color.green, 
              "#{@title} listening on port #{app.address().port} in #{app.settings.env} mode"
            log '---', color.green
  
  
  ###
  Configures the library.
  @param app :       The express app.
  @param options:
          - baseUrl:  Optional. The base URL path to put the Core app within (default: /core).
          - express:  Optional. The instance of Express being used.
          - callback: Optional. Function to invoke upon completion.
  ###
  init: (app, options = {}) -> 
    
    # Setup initial conditions.
    callback = options.callback
    paths    = @paths
    baseUrl  = options.baseUrl ?= '/core'
    baseUrl  = _.trim(baseUrl)
    baseUrl  = '' if baseUrl is '/'
    
    # Store values on module.
    @options = options
    @baseUrl = baseUrl
    @app     = app if app?
    
    # Initialize sibling modules.
    require './config/express'
    require './config/testing'
    require './routes'
    
    build = (callback) => 
      log '  Building:', color.blue, 'Open.Core javascript...'
      timer = new @util.Timer()
      @build.all -> 
        log '  - Built', color.blue, "in #{timer.secs()} seconds"
        callback?()
    
    # Build client-side JavaScript.
    build(callback)


# PRIVATE --------------------------------------------------------------------------


log = (message, color = '', explanation = '') ->
  return if core.isSubModule
  core.log message, color, explanation


# Bootstrap.
do -> 
  
  # Initialize 3rd party libs.
  require './config/libs'
  
  # Store sub-modules.
  # NB: Set here to avoid load order problems with sub-modules that
  #     in turn require the [server] module.
  core.paths       = require './config/paths'
  core.client      = require 'open.client'
  core.version     = core.client.core.version
  core.mvc         = core.client.core.mvc
  core.util        = require './util'
  core.log         = core.util.log
  core.modules     = require './modules'
  core.build        = require './config/build'
  
  # Test runners.
  core.init.specs   = require './routes/testing/jasmine'
  core.init.harness = require './routes/testing/harness'
  
  # Store a reference to whether this is running as a sub-module of
  # another project, or stand-alone.
  core.isSubModule = not _(process.env.PWD).endsWith 'open.core'


