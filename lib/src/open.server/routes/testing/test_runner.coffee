fs           = require 'fs'
CoffeeScript = require 'coffee-script'
core         = require '../../../open.server'
util         = core.util


###
A generic test-runner page.
###
module.exports = class TestRunner
  ###
  Constructor.
  @param app express/connect that the test runner is operating within.
  @param options:
          - view  : The path to the .jade view.
  ###
  constructor: (@app, options = {}) -> 
      @render = util.render
      @view   = options.view
  
  
  ###
  Renders the root page containing the test-runner.
  @returns res    : The repsonse object.
  @param options  : The options to pass to the .jade template.
  ###
  renderRoot: (res, options = {}) -> @render res, @view, options
    
  
  ###
  Initializes the routes for the test-runner.
  @param options:
      - url              : (optional) The URL that loads the test-runner (defaults to /specs).
      - title            : (optional) The page title (defaults to 'Specs').
      - specsDir         : The path to the directory containing the client-side specs.
      - sourceUrls       : An array or URLs (or a single URL) pointing to the source script(s)
                           that are under test.
      - samplesDir       : Optional. The path to a directory of samples to compile and serve as commonJS modules.
      - samplesNamespace : Optional. The root namespace to compile sample code under (see 'samplesDir').
      - css              : Optional. The URL (or array of URL's) for style sheets to include in the page.
      - libsJs           : Optional. The path so the 3rd party libs file to use. (Default: The core 'libs-min.js' file.)
  ###
  init: (options = {}) -> 
    
      # Format default values.
      options.url ?= '/specs'
      options.title ?= 'Specs'
      options.specsDir   = _.rtrim(options.specsDir ?= "#{process.env.PWD}/test/specs", '/')
      options.samplesDir = _.rtrim(options.samplesDir, '/') if options.samplesDir?
      options.sourceUrls = options.sourceUrls ?= []
      options.sourceUrls = [options.sourceUrls] if not _.isArray(options.sourceUrls)
      options.css       ?= []
      options.css        = [options.css] if not _.isArray(options.css)
      options.libsJs    ?= "#{core.baseUrl}/javascripts/libs/libs-min.js"
      
      # Configure strings.
      strings = options.strings ?= {}
      strings.suites ?= 'Suites'
      strings.specs  ?= 'Specs'
      
      # Store variables.
      app = @app
      url = options.url
      
      # GET: The test runner page.
      app.get url, (req, res) =>
          
          # Ensure the path ends with a '/'
          unless _(req.url).endsWith '/'
                res.redirect req.originalUrl + '/'
                return
          
          # Retrieve paths to script files.
          getHelpers options.specsDir, (helperPaths) =>
            getSpecs options.specsDir, (specPaths) =>
                options.helperPaths = helperPaths
                options.specPaths   = specPaths
                
                @renderRoot res, 
                    layout:         false
                    pretty:         true
                    core:           core
                    options:        options
                    sampleCode:     "#{url}/samples"
      
      # GET: The spec file.
      app.get "#{url}/specs/*", (req, res) =>
        
          # Setup initial conditions.
          path = req.params[0]
          file = "#{options.specsDir}/#{req.params[0]}"
          extension = _(file).strRightBack('.')
        
          if extension is 'js'
            # Send the standard JavaScript file.
            util.send.scriptFile res, file
          else if extension is 'coffee'
         
            # Compile the coffee script.
            compileCoffee file, (script) -> util.send.script res, script
          
          else
            # Unknown script type/
            res.send "Script type [.#{extension}] not supported", 415
      
      
      # GET: The sample code compiled as CommonJS modules.
      app.get "#{url}/samples", (req, res) =>
          send = (code) -> util.send.script res, code
          if not options.samplesDir?
            util.send.script res, '/* No sample code */' # No code to send.
          else
            path = 
                path:      options.samplesDir
                namespace: options.samplesNamespace
                deep:      true
            new util.javascript.Builder(path).build (code) -> send code(false)


# PRIVATE --------------------------------------------------------------------------


include = (file, endsWith) ->
    for ending in endsWith
      return true if _(file).endsWith(ending)
    false

getFiles = (dir, endsWith, callback) ->
    dir = _.rtrim(dir, '/') + '/'
    util.fs.flattenDir dir, hidden:false, (err, paths) ->
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
          throw "Failed to compile spec file: #{file} \n#{error.message}"


