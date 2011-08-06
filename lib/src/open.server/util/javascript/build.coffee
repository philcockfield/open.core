module.exports =
  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  @param callback: invoked upon completion.
  ###
  libs: (callback) ->
        core = require 'open.server'
        libs = "#{core.paths.public}/javascripts/libs"
        src = "#{libs}/src"
        paths = [
          "#{src}/jquery-1.6.2.js"
          "#{src}/underscore-1.1.6.js"
          "#{src}/underscore.string-1.1.5.js"
          "#{src}/backbone-0.5.1.js"
        ]

        options =
            paths: paths
            standard: "#{libs}/libs.js"
            minified: "#{libs}/libs-min.js"
        core.util.fs.concatenate.save options, -> callback?()


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
      folder    = "#{core.paths.public}/javascripts"
      copyright = core.copyright(asComment: true)
      output =
          packed:   "#{folder}/core.js"
          minified: "#{folder}/core-min.js"

      # Construct paths.
      clientPath = core.paths.client
      paths = [
        { source: "#{clientPath}/core", target: '/open.client/core' }
        { source: "#{clientPath}/controls", target: '/open.client/controls' }
        ]

      # Compile and save.
      compiler  = new core.util.javascript.Compiler paths, header: copyright
      if options.save == true
        compiler.save
              packed:         output.packed
              minified:       output.minified
              callback:       options.callback
      else
        compiler.build (code) ->
              code.paths = output
              options.callback?(code)
