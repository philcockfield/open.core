module.exports =
    ###
    Initializes the routes.
    @param core: the root Open.Core server module.
    ###
    init: (core) ->
      app     = core.app
      baseUrl = core.baseUrl
      paths   = core.paths
      send    = core.util.send

      console.log 'baseUrl', baseUrl

      # Routes.
      # Send from file.
      app.get "#{baseUrl}/libs:min?.js", (req, res) ->
            libs = "#{paths.public}/javascripts/libs"
            min = ''
            min = '-min' if req.params.min == '-min'
            core.util.send.scriptFile res, "#{libs}/libs#{min}.js"


      app.get "#{baseUrl}/build/:package?.js", (req, res) =>
          package   = req.params.package
          minified  = _(package).endsWith '-min'

          switch req.params.package
            when 'core', 'core-min'
                # Serve fresh version of the file (but don't save).
                compiler = new core.util.javascript.Compiler(paths.client)
                compiler.build minified, (code) -> send.script res, code
            else
              res.send 404
