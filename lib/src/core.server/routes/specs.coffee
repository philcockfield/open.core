fs = require 'fs'
CoffeeScript = require 'coffee-script'


###
Configures the Jasmine BDD spec runner.
@param app express/connect that the test runner is operating within.
@param options:
        - url         : (optional) The URL that loads the test-runner (defaults to /specs).
        - title       : (optional) The page title (defaults to 'Specs').
        - specsDir    : The path to the directory containing the client-side specs.
        - sourceUrls  : With an array or URLs (or a single URL) to the source scripts that are under test.
###
module.exports = (app, options) ->

    # Setup initial conditions.
    core = require 'core.server'
    url = options.url ?= '/specs'
    title = options.title ?= 'Specs'
    specsDir = options.specsDir ?= "#{process.env.PWD}/test/specs"
    sourceUrls = options.sourceUrls ?= []
    sourceUrls = [sourceUrls] if not _.isArray(sourceUrls)

    console.log 'sourceUrls', sourceUrls


    isSpec = (file) -> _(file).endsWith('_spec.coffee') or _(file).endsWith('_spec.js')

    getSpecs = (dir, callback) ->
        dir = _.rtrim(dir, '/') + '/'
        core.util.fs.flattenDir dir, hidden:false, (err, paths) ->
              throw err if err?
              paths = _.map paths, (file) -> _(file).strRight(dir) if isSpec(file)
              paths = _.compact(paths)
              callback?(paths)

    compileCoffee = (file, callback) ->
        fs.readFile file, 'utf8', (err, data) ->
            callback CoffeeScript.compile(data)


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
                                  sourceUrls: sourceUrls


    # Route: The spec file.
    core.app.get "#{url}/specs/*", (req, res) ->

        # Setup initial conditions.
        file = "#{specsDir}/#{req.params[0]}"
        extension = _(file).strRightBack('.')

        if extension is 'js'
          # Send the standard JavaScript file.
          core.util.send.scriptFile res, file
        else if extension is 'coffee'

          # Compile the coffee script.
          compileCoffee file, (script) -> core.util.send.script res, script

        else
          # Unknown script type/
          res.send "Script type [.#{extension}] not supported", 415




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
