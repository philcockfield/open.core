core    = require '../'
options = core.options


# Setup initial conditions.
baseUrl = core.baseUrl
paths   = core.paths

# Create a new express app if one was not passed in from the hosting app.
express = options.express ?= require('express')
app     = core.app ?= express.createServer()

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

