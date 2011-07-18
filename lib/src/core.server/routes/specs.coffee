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
    options.url = options.url ?= '/specs'
    options.title = options.title ?= 'Specs'

    isSpec = (file) ->
          _(file).endsWith('_spec.js') or _(file).endsWith('_spec.coffee')


    getSpecs = (dir, callback) ->
        fs = core.util.fs
        fs.flattenDir dir, hidden:false, (err, paths) ->
            throw err if err?
            paths = _.map paths, (file) -> return file if isSpec(file)
            paths = _.compact(paths)

            for path in paths
              console.log ' >> SPEC: ', path
            console.log ''



    # The test runner.
    core.app.get options.url, (req, res) ->
        getSpecs options.specsDir, (specPaths) ->
            libFolder = "#{core.baseUrl}/javascripts/libs/jasmine"
            core.util.render res, 'specs/index',
                                  title:      options.title
                                  layout:     false
                                  baseUrl:    core.baseUrl
                                  libFolder:  libFolder


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
