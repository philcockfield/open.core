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
        - samplesDir:   Optional. The path to a directory of samples to compile and serve as commonJS modules.
###
module.exports = (app, options) ->
    
    # Setup initial conditions.
    core       = require 'open.server'
    url        = options.url ?= '/specs'
    title      = options.title ?= 'Specs'
    specsDir   = _.rtrim(options.specsDir ?= "#{process.env.PWD}/test/specs", '/')
    samplesDir = _.rtrim(options.samplesDir, '/')if options.samplesDir?
    sourceUrls = options.sourceUrls ?= []
    sourceUrls = [sourceUrls] if not _.isArray(sourceUrls)
    
    include = (file, endsWith) ->
        for ending in endsWith
          return true if _(file).endsWith(ending)
        false
    
    getFiles = (dir, endsWith, callback) ->
        dir = _.rtrim(dir, '/') + '/'
        core.util.fs.flattenDir dir, hidden:false, (err, paths) ->
              if err?
                err.message = "Could not load specs from the directory: #{dir}"
                throw err
              paths = _.map paths, (file) -> _(file).strRight(dir) if include(file, endsWith)
              paths = _.compact(paths)
              callback?(paths)
    
    getSpecs   = (dir, callback) -> getFiles dir, ['_spec.coffee', '_spec.js'], callback
    getHelpers = (dir, callback) -> getFiles dir, ['_helper.coffee', '_helper.js'], callback
    
    compileCoffee = (file, callback) ->
        fs.readFile file, 'utf8', (err, data) ->
            try
              callback CoffeeScript.compile(data)
            catch error
              msg = "Failed to compile spec file: #{file} \n#{error.message}"
              throw msg
              
    
    # Route: The test runner.
    app.get url, (req, res) ->
        getHelpers specsDir, (helperPaths) ->
          getSpecs specsDir, (specPaths) ->
              libFolder = "#{core.baseUrl}/javascripts/libs/jasmine"
              core.util.render res, 'specs/index',
                                    layout:       false
                                    title:        title
                                    url:          url
                                    libFolder:    libFolder
                                    specPaths:    specPaths
                                    helperPaths:  helperPaths
                                    sourceUrls:   sourceUrls
                                    sampleCode:   "#{url}/samples"
    
    # Route: The spec file.
    app.get "#{url}/specs/*", (req, res) ->
        
        # Setup initial conditions.
        path = req.params[0]
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
    
    
    # Route: Compiled sample code (CommonJS)
    app.get "#{url}/samples", (req, res) ->
        send = (code) -> core.util.send.script res, code
        if not samplesDir?
          send '' # No code to send.
        else
          path = 
              path:      samplesDir
              namespace: 'core/test'
              deep:      true
          new core.util.javascript.Builder(path).build (code) -> send code(false)

