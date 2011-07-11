module.exports =
    ###
    Initializes the routes.
    @param core: the root Open.Core server module.
    ###
    init: (core) ->
      app = core.app
      baseUrl = core.baseUrl
      paths = core.paths

      console.log 'base', baseUrl

      # Routes.
      # Send from file.
      app.get "#{baseUrl}/libs:min?.js", (req, res) ->
            libs = "#{paths.public}/javascripts/libs"
            min = ''
            min = '-min' if req.params.min == '-min'
            core.util.send.scriptFile res, "#{libs}/libs#{min}.js"

