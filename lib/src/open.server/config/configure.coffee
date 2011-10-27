core = require 'open.server'
log  = core.log

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
    
    # Build client-side JavaScript.
    switch core.app.settings.env
      when 'development'
        log '  Building:', color.blue, 'Open.Core client-side javascript...'
        timer = new core.util.Timer()
        core.util.javascript.build.all 
                      save: true, 
                      callback: -> 
                          log '  - Javascript built', color.blue, "in #{timer.secs()} seconds"
                          callback?()
      else 
        callback?()

