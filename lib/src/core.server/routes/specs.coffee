###
Configures the Jasmine BDD spec runner.
@param app express/connect that the test runner is operating within.
@param options:
        - url         : (optional) The URL that loads the test-runner (defaults to /specs).
        - title       : (optional) The page title (defaults to 'Specs').
        - specsDir    : The path to the directory containing the client-side specs.
###
module.exports = (app, options) ->

    # Setup initial conditions.
    core = require 'core.server'
    url = options.url ?= '/specs'
    title = options.title ?= 'Specs'
    specsDir = options.specsDir ?= "#{process.env.PWD}/test/specs"

    console.log 'specsDir', specsDir

    isSpec = (file) -> _(file).endsWith('_spec.coffee') or _(file).endsWith('_spec.js')
    getSpecs = (dir, callback) ->
        dir = _.rtrim(dir, '/') + '/'
        core.util.fs.flattenDir dir, hidden:false, (err, paths) ->
              throw err if err?
              paths = _.map paths, (file) -> _(file).strRight(dir) if isSpec(file)
              paths = _.compact(paths)
              callback?(paths)


    # Route: The test runner.
    core.app.get url, (req, res) ->
        getSpecs specsDir, (specPaths) ->
            libFolder = "#{core.baseUrl}/javascripts/libs/jasmine"
            core.util.render res, 'specs/index',
                                  layout:     false
                                  title:      title
                                  url:        url
                                  libFolder:  libFolder
                                  specPaths:  specPaths


    # Route: The spec file.
    core.app.get "#{url}/specs/:file", (req, res) ->
        file = req.params.file

        res.send 404

        console.log ' >> ', req.params


#exports.init = (routes) ->
#
#
#    return
#
#    core = require 'core.server'
#    baseUrl = routes.baseUrl
#    send    = core.util.send
#
#
#
#    # The source files under test.
#    routes.app.get "#{baseUrl}/specs/:type", (req, res) ->
#         minified = req.query.min == 'true'
#
#         switch req.params.type
#           when 'source' then folder = routes.paths.client
#           when 'tests' then folder = routes.paths.specs
#           else
#              res.send 404
#              return
#
#
#         send.script res, "console.log('todo - specs: #{req.params.type}');"
##         compiler = new core.util.javascript.Compiler( source: folder, target: '/' )
##         compiler.build minified, (code) -> send.script res, code
#
#
#
