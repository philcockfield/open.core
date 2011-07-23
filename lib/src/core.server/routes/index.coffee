module.exports =
  ###
  Initializes the routes.
  @param core: the root Open.Core server module.
  ###
  init: ->
      # Setup initial conditions.
      core    = require 'core.server'
      app     = core.app
      paths   = core.paths

      # Helpers.
      minRequested = (req)-> _(req.params.package).endsWith '-min'

      # Routes.
      app.get "#{core.baseUrl}/:package?.js", (req, res) ->
          min = if minRequested(req) then '-min' else ''
          switch req.params.package
            when 'libs', 'libs-min'
              file = "#{paths.public}/javascripts/libs/libs#{min}.js"
            else
              res.send 404
              return
          core.util.send.scriptFile res, file
