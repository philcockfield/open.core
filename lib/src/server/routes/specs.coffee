exports.init = (routes) ->
    core    = routes.core
    baseUrl = routes.baseUrl
    send    = core.util.send

    # The test runner.
    routes.app.get "#{baseUrl}/specs", (req, res) ->
        libFolder = "#{baseUrl}/javascripts/libs/jasmine"

        routes.render res, 'specs/index',
                              title:      'Open.Core Specs',
                              layout:     false
                              baseUrl:    baseUrl
                              libFolder:  libFolder


    # The source files under test.
    routes.app.get "#{baseUrl}/specs/:type", (req, res) ->
         minified = req.query.min == 'true'

         switch req.params.type
           when 'source' then folder = routes.paths.client
           when 'tests' then folder = routes.paths.specs
           else
              res.send 404
              return

         compiler = new core.util.javascript.Compiler( source: folder, target: '/' )
         compiler.build minified, (code) -> send.script res, code



