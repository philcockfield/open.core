fs       = require 'fs'
stitch   = require 'stitch'
minifier = require './minifier'

writeResponse = (compiler, options)->
        res = options.writeResponse
        return unless res?
        res.write "---------------------------------------\n"
        res.write "  JavaScript Compile\n"
        res.write "---------------------------------------\n\n"
        res.write "Packed to: #{options.packed}\n"
        res.write "Minified to: #{options.minified}\n\n"
        res.write "Packed length: #{compiler.packed.length} characters\n"
        res.write "Minified length: #{compiler.minified.length} characters\n\n\n\n"
        res.write "#{compiler.minified}\n\n\n\n"
        res.write "#{compiler.packed}\n\n\n"
        res.end()

module.exports = class Compiler
  constructor: (@paths) ->
        @paths = [@paths] unless _.isArray(@paths)
        @package = stitch.createPackage( paths:@paths )

  ###
  Stitches the code at the paths (given to the constructor)
  into a single file.
  @param callback(code): invoked when complete with the produced code.
  ###
  pack: (callback) ->
          self = @
          @package.compile (err, code) ->
                            throw err if err?
                            self.packed = code
                            callback?(code)

  ###
  Compresses the code.
  @param callback(code): invoked when complete with the produced code.
  ###
  minify: (callback, code = null) ->
          self = @

          # Minify the javascript.
          minify = (c) ->
               minifier.compress c, (min)->
                  self.minified = min
                  callback?(min)

          # Get the raw javascript.
          if code?
            minify(code)
          else
            @pack (c)-> minify(c)

  ###
  Either packs or minifies the code based on the given flag.
  @param callback : invoked upon completion (optional).
                      Passes a function with two properties:
                        - packed: the packed code
                        - minified: the minified code if a minified path was specified
                      The function can be invoked like so:
                        fn(minified):
                          - minified: true - returns the minified code.
                          - minified: false - returns the unminified, packed code.
  ###
  build: (callback) ->
          self = @
          @minify (code) ->
              result = (minified) -> if minified then self.minified else self.packed
              result.minified = self.minified
              result.packed = self.packed
              callback? result


  ###
  Saves the code to the specified files.
  @param options:
            - minified      : the file to save the minified file to (optional).
            - packed        : the file to save the packed file to (optional).
            - writeResponse : a response object to write output details to.
            - callback      : invoked upon completion (optional).
                              Passes a function with two properties:
                                - packed: the packed code
                                - minified: the minified code if a minified path was specified
                              The function can be invoked like so:
                                fn(minified):
                                  - minified: true - returns the minified code.
                                  - minified: false - returns the unminified, packed code.
  ###
  save: (options) ->
      return unless options?
      self     = @
      core     = require 'core.server'

      # 1. Build the code.
      @build (code) ->
          writeResponse self, options
          code.paths =
              packed: options.packed
              minified: options.minified

          # Construct the list of files to save.
          files = []
          if options.minified?
            files.push path:options.minified, data: code(true)

          if options.packed?
            files.push path:options.packed, data: code(false)

          # 2. Save the file(s) to disk.
          core.util.fs.writeFiles files, (err) -> options.callback?(code)
