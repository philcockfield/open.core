Builder = require './build/builder'

CoreBuilder: class CoreBuilder
  constructor: (@save = true,  @dir = 'core') -> 
      core       = require 'open.server'
      @dir       = "#{core.paths.javascripts}/#{@dir}"
      @copyright = core.copyright(asComment: true)
      
      # Construct paths.
      client = core.paths.client
      @path =
        core:     { path: "#{client}/core",     namespace: 'open.client/core' }
        controls: { path: "#{client}/controls", namespace: 'open.client/controls' }
  
  build: (name, paths, callback)-> 
      paths = [paths] unless _(paths).isArray()
      builder = new Builder( paths, header:@copyright )
      builder.build (code) => 
          if @save is yes
            builder.save dir:@dir, name:name, (code) -> callback? code
          else
            callback? code
  
  coreControls: (callback) -> @build 'core+controls', [ @path.core, @path.controls ], callback
  core:         (callback) -> @build 'core', @path.core, callback
  controls:     (callback) -> @build 'controls', @path.controls, callback

module.exports =
  ###
  Builds the entire client scripts to a single package.
  @param options:
            - save:         : flag indicating if the code should be saved to disk (default false).
            - callback      : invoked upon completion (optional).
                              Passes a function with two properties:
                                - packed: the packed code
                                - minified: the minified code if a minified path was specified
                              The function can be invoked like so:
                                fn(minified):
                                  - minified: true - returns the minified code.
                                  - minified: false - returns the unminified, packed code.
  ###
  all: (options = {}) -> 
      callback = options.callback
      builder = new CoreBuilder(options.save)
      
      builder.coreControls (coreControls) -> 
        builder.core (core) -> 
          builder.controls (controls) -> 
            callback? coreControls
  
  
  ###
  The core builder.
  ###
  CoreBuilder: CoreBuilder


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
          'jquery-1.6.2.js'
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

