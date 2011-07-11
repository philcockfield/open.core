express = require 'express'
routes  = require '../routes'

###
Configures the Open.Core module
@param core: The root Open.Core module.
###
module.exports = (core) ->

    # Setup initial conditions.
    app     = core.app
    baseUrl = core.baseUrl
    paths   = core.paths

    # Initialize the open.core library

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
    routes.init core



