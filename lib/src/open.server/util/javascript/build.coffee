module.exports =
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
          "jquery-1.6.2.js"
          "underscore-1.1.6.js"
          "underscore.string-1.1.5.js"
          "backbone-0.5.1.js"
          "spin.js"
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
      core      = require 'open.server'
      dir    = "#{core.paths.public}/javascripts"
      copyright = core.copyright(asComment: true)

      # Construct paths.
      clientPath = core.paths.client
      paths = [
        { path: "#{clientPath}/core",     namespace: 'open.client/core' }
        { path: "#{clientPath}/controls", namespace: 'open.client/controls' }
      ]
      
      builder = new core.util.javascript.Builder(paths, includeRequireJS:true)
      builder.build (code) -> 
          if options.save is yes
            builder.save dir:dir, name: 'core', (code)-> 
              options.callback? code
          
          else
            options.callback? code

