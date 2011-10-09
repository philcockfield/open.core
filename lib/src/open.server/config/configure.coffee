core = require 'open.server'

###
Configures the library.
@param app :       The express app.
@param options:
        - baseUrl: The base URL path to put the Core app within (default: /core).
        - express: The instance of Express being used.
###
module.exports = (app, options = {}) ->
    
    # Modules.
    express = options.express ?= require('express')
    routes  = require '../routes'
    
    # Create a new express app if one was not passed.
    app ?= express.createServer()
    
    # Setup initial conditions.
    paths   = core.paths
    baseUrl = options.baseUrl ?= '/core'
    baseUrl = _.trim(baseUrl)
    baseUrl = '' if baseUrl is '/'
    
    # Store values on module.
    core.baseUrl = baseUrl
    core.app     = app
    
    # Build client-side JavaScript.
    core.util.javascript.build.all( save: true ) if app.settings.env is 'development'
    
    # Setup Express.
    do -> 
          # Put middleware within the given URL namespace.
          use = (middleware) ->
              if baseUrl is '/'
                  # Running from the local project (dev/debug).  Don't namespace the url.
                  app.use middleware
              else
                  app.use baseUrl, middleware
    
          # Configuration.
          app.configure ->
              use express.bodyParser()
              use express.methodOverride()
              use express.cookieParser()
              require('./css').configure use # CSS pre-processor (Stylus).
              use express.static(paths.public)
              use app.router
        
          app.configure 'development', ->
              use express.errorHandler( dumpExceptions: true, showStack: true )
    
          app.configure 'production', ->
              use express.errorHandler()
    
    # Unit-test runner (specs).
    core.configure.specs app,
          title:      'Open.Core Specs'
          url:        "#{baseUrl}/specs"
          specsDir:   "#{core.paths.specs}/client/"
          samplesDir: "#{core.paths.specs}/client/samples"
          sourceUrls: [
            "#{baseUrl}/libs.js"
            "#{baseUrl}/core+controls.js" ]
    
    # TestHarness.
    core.configure.harness app,
          title:      'Open.Core TestHarness'
          url:        "#{baseUrl}/harness"
          specsDir:   "#{core.paths.test}/harness/"
          sourceUrls: [
            "#{baseUrl}/libs.js"
            "#{baseUrl}/core+controls.js" ]
    
    
    # Setup routes.
    routes.init()
