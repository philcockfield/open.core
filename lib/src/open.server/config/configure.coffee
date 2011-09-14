###
Configures the library.
@param options:
        - baseUrl: The base URL path to put the Core app within (default: /core).
        - express: The instance of Express being used.
###
module.exports = (app, options = {}) ->

    # Modules.
    core    = require 'open.server'
    express = options.express ?= require('express')
    routes  = require '../routes'

    # Setup initial conditions.
    paths   = core.paths
    baseUrl = options.baseUrl ?= '/core'
    baseUrl = _.trim(baseUrl)
    baseUrl = '' if baseUrl is '/'

    # Store values on module.
    core.baseUrl = baseUrl
    core.app = app

    # Build client-side JavaScript.
    core.util.javascript.build.all( save: true ) if app.settings.env is 'development'

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

        # Setup the client-side test runner.
        core.configure.specs app,
              title:      'Open.Core Specs'
              url:        "#{baseUrl}/specs"
              specsDir:   "#{core.paths.test}/specs/client/"
              samplesDir: "#{core.paths.test}/specs/client/samples"
              sourceUrls: [
                "#{baseUrl}/libs.js"
                "#{baseUrl}/core.js" ]


    app.configure 'production', ->
        use express.errorHandler()

    # Setup routes.
    routes.init()


