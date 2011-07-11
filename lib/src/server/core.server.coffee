express = require 'express'
routes  = require './routes'

require './config/libs'


module.exports =
  title:  'Open.Core (Server)'
  paths:  require './config/paths'
  util:   require './util/util'

  ###
  Configures the library.
  @param options:
          - baseUrl: The base URL path to put the TestHarness within (default: /testharness).
  ###
  configure: (app, options = {}) ->
        # Setup initial conditions.
        baseUrl = options.baseUrl ?= '/core'
        paths   = @paths

        # Store on module.
        @baseUrl = baseUrl
        @app = app

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
            use require('stylus').middleware( src: paths.public )

            use app.router
            use express.static(paths.public)

        app.configure 'development', ->
            use express.errorHandler( dumpExceptions: true, showStack: true )

        app.configure 'production', ->
            use express.errorHandler()

        # Setup routes.
        routes.init @

