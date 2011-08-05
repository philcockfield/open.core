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

      # Helpers.
      minRequested = (req)-> _(req.params.package).endsWith '-min'

      # Routes.
      app.get "#{core.baseUrl}/:package?.js", (req, res) ->
          package = req.params.package
          min  = if minRequested(req) then '-min' else ''
          dir  = "#{paths.public}/javascripts"
          file = (name) -> 
                  name = _.strLeftBack(name, '-min')
                  "#{name}#{min}.js"
      
          switch req.params.package
            when 'libs', 'libs-min' then file = "#{dir}/libs/#{file('libs')}"
            else
              file = "#{dir}/#{file(package)}"

          core.util.send.scriptFile res, file
