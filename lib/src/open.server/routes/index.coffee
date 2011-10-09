module.exports =
  ###
  Initializes the routes.
  @param core: the root Open.Core server module.
  ###
  init: ->
      # Setup initial conditions.
      core    = require 'open.server'
      app     = core.app
      paths   = core.paths
      send    = core.util.send

      # Helpers.
      minRequested = (req)-> _(req.params.package).endsWith '-min'

      # Routes.
      
      # GET: Stylesheets
      app.get "#{core.baseUrl}/:stylesheet?.css", (req, res) ->
          stylesheet = req.params.stylesheet
          switch stylesheet
            when 'normalize' then path = 'libs'
            else path = 'core'
          send.cssFile res, "#{paths.stylesheets}/#{path}/#{stylesheet}.css"
      
      # GET: Javascript file.
      app.get "#{core.baseUrl}/:package?.js", (req, res) ->
          package = req.params.package
          min  = if minRequested(req) then '-min' else ''
          dir  = "#{paths.public}/javascripts"
          file = (name) -> 
                  name = _.strLeftBack(name, '-min')
                  "#{name}#{min}.js"
          libFile = (name) -> "#{dir}/libs/#{file(name)}"
      
          # Look for lib files.
          switch package
            when 'libs', 'libs-min' then file = libFile 'libs'
            when 'require', 'require-min' then file = libFile 'require'
            else
              # Not a lib file, return the core java-script.
              file = "#{dir}/core/#{file(package)}"

          send.scriptFile res, file
