core = require 'open.server'


log = (message, color = '', explanation = '') ->
    return # Temporarily don't write out.  Figure out how to only write this when running in Core app
    core.log message, color, explanation


###
Configures the library.
@param app :       The express app.
@param options:
        - baseUrl:  Optional. The base URL path to put the Core app within (default: /core).
        - express:  Optional. The instance of Express being used.
        - callback: Optional. Function to invoke upon completion.
###
module.exports = (app, options = {}) ->
    
    # Setup initial conditions.
    callback = options.callback
    paths    = core.paths
    baseUrl  = options.baseUrl ?= '/core'
    baseUrl  = _.trim(baseUrl)
    baseUrl  = '' if baseUrl is '/'
    
    # Store values on module.
    core.options = options
    core.baseUrl = baseUrl
    core.app     = app if app?
    
    # Initialize sibling modules.
    require './express'
    require './testing'
    require '../routes'
    
    build = (callback) -> 
      log '  Building:', color.blue, 'Open.Core client-side javascript...'
      timer = new core.util.Timer()
      core.util.javascript.build.all -> 
        log '  - Javascript built', color.blue, "in #{timer.secs()} seconds"
        callback?()
    
    # Build client-side JavaScript.
    build(callback)

