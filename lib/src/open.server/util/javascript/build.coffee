core      = require 'open.server'
Builder   = require './build/builder'
ModuleDef = require '../module_def'

# Initialize the module builder system.
ModuleDef.registerPath core.paths.client
ModuleDef.defaults.header = core.copyright asComment:true


buildList =
  core:     false
  controls: true    # Include dependencies.
  auth:     false
  harness:  true    # Include dependencies.


module.exports = build = 
  ###
  Builds the entire set of client side scripts.
  @param callback: invoked upon completion (optional).
  ###
  all: (callback) -> 
    count = 0
    for key of buildList
      count += 1
      @[key] => 
        count -= 1
        callback?() if count is 0
  
  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  @param callback: invoked upon completion.
  ###
  libs: (callback) ->
        core       = require 'open.server'
        fs         = core.util.fs
        sourceLibs = "#{__dirname}/libs.src"
        targetLibs = "#{core.paths.public}/javascripts/libs"
        
        # Note: Order is important.  Underscore must come before Backbone.
        paths = [
          'jquery-1.7.1.js'
          'underscore-1.1.6.js'
          'underscore.string-1.1.5.js'
          'backbone-0.5.1.js'
          'spin.js'
          'require.js'
        ]
        paths = _(paths).map (path) -> "#{sourceLibs}/#{path}"
        
        # Concatenate the JS libraries into a single file and save.
        options =
            paths: paths
            standard: "#{targetLibs}/libs.js"
            minified: "#{targetLibs}/libs-min.js"
        fs.concatenate.save options, -> 
            
            # Copy the [require.js] file.
            fs.copy "#{sourceLibs}/require.js", "#{targetLibs}/require.js", -> 
            
                # Finish up.
                callback?()


# PRIVATE --------------------------------------------------------------------------


save = (name, options..., callback) -> 
  options = options[0] ? {}
  module = ModuleDef.find name
  throw "Cannot find module [#{name}]" unless module?
  module.save "#{core.paths.javascripts}/core", options, callback


# Initialize.
for key of buildList
  do (key) -> 
    build[key] = (callback) -> 
      save "open.client/#{key}", 
        includeDependencies:buildList[key], 
        callback


