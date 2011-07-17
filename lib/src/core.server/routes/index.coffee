module.exports =
  ###
  Initializes the routes.
  @param core: the root Open.Core server module.
  ###
  init: ->
      # Setup initial conditions.
      core    = require 'core.server'
      paths   = core.paths

      # Routes.
      # Send from file.
      core.app.get "#{core.baseUrl}/libs:min?.js", (req, res) ->
            libs = "#{paths.public}/javascripts/libs"
            min = ''
            min = '-min' if req.params.min == '-min'
            core.util.send.scriptFile res, "#{libs}/libs#{min}.js"


