fs = require 'fs'
CoffeeScript = require 'coffee-script'


###
Configures the Jasmine BDD spec runner.
@param app express/connect that the test runner is operating within.
@param options:
        - url         : (optional) The URL that loads the test-runner (defaults to /specs).
        - title       : (optional) The page title (defaults to 'Specs').
        - specsDir    : The path to the directory containing the client-side specs.
        - sourceUrls  : An array or URLs (or a single URL) pointing to the source script(s)
                        that are under test.
###
module.exports = (app, options) ->

    # Setup initial conditions.
    core       = require 'open.server'
    url        = options.url ?= '/specs'
    title      = options.title ?= 'Specs'
    specsDir   = options.specsDir ?= "#{process.env.PWD}/test/specs"
    sourceUrls = options.sourceUrls ?= []
    sourceUrls = [sourceUrls] if not _.isArray(sourceUrls)

    isSpec = (file) ->
        for ending in ['_spec.coffee', '_helper.coffee', '_spec.js', '_helper.js']
          return true if _(file).endsWith(ending)
        false

    getSpecs = (dir, callback) ->
        dir = _.rtrim(dir, '/') + '/'
        core.util.fs.flattenDir dir, hidden:false, (err, paths) ->
              if err?
                err.message = "Could not load specs from the directory: #{dir}"
                throw err
              paths = _.map paths, (file) -> _(file).strRight(dir) if isSpec(file)
              paths = _.compact(paths)
              callback?(paths)

    compileCoffee = (file, callback) ->
        fs.readFile file, 'utf8', (err, data) ->
            callback CoffeeScript.compile(data)


    # Route: The test runner.
    app.get url, (req, res) ->
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
    app.get "#{url}/specs/*", (req, res) ->

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

