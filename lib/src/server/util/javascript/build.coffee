fs = require 'fs'

module.exports =
  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  @param callback: invoked upon completion.
  ###
  libs: (callback) ->
        core = require 'core.server'
        libs = "#{core.paths.public}/javascripts/libs"
        src = "#{libs}/src"
        paths = [
          "#{src}/jquery-1.6.2.js"
          "#{src}/underscore-1.1.6.js"
          "#{src}/underscore.string-1.1.5.js"
          "#{src}/backbone-0.5.1.js"
        ]

        console.log "Saving lib files to: #{libs}"
        console.log '...'

        options =
            paths: paths
            standard: "#{libs}/libs.js"
            minified: "#{libs}/libs-min.js"
        core.util.fs.concatenate.save options, ->
                  console.log 'Done'
                  callback?()



  ###
  Builds the entire client scripts to a single package.
  @param options:
            - writeResponse : a response object to write output details to (optional).
            - save:         : flag indicating if the code should be saved to disk.
            - callback      : invoked upon completion (optional).
                              Passes a function with two properties:
                                - packed: the packed code
                                - minified: the minified code if a minified path was specified
                              The function can be invoked like so:
                                fn(minified):
                                  - minified: true - returns the minified code.
                                  - minified: false - returns the unminified, packed code.
  ###
  client: (options = {}) ->
      core      = require 'core.server'
      folder    = "#{core.paths.public}/javascripts"
      copyright = core.copyright(asComment: true)
      paths =
          packed:   "#{folder}/core.js"
          minified: "#{folder}/core-min.js"

      compiler  = new core.util.javascript.Compiler core.paths.client, header: copyright
      if options.save
        compiler.save
              packed:         paths.packed
              minified:       paths.minified
              writeResponse:  options.writeResponse
              callback:       options.callback
      else
        compiler.build (code) ->
              code.paths = paths
              options.callback?(code)

