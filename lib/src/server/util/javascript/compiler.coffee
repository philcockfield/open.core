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
  @param minified: Flag indicating if the code should be minified.
  @param callback(code): invoked when complete with the produced code.
  ###
  build: (minified, callback) ->
              if minified
                 @minify (code) -> callback?(code)
              else
                 @pack (code) -> callback?(code)


  ###
  Saves the code to the specified files.
  @param options:
            - minified      : the file to save the minified file to (optional).
            - packed        : the file to save the packed file to (optional).
            - callback      : invoked upon completion (optional).
            - writeResponse : a response object to write output details to.
  ###
  save: (options) ->
      return unless options?
      self = @
      callback = options.callback

      # Determine total number of save operations.
      total = 0
      total += 1 if options.minified
      total += 1 if options.packed
      if total == 0
          callback?()
          return

      # Write to disk.
      saved = 0
      write = (file, code) ->
                fs.writeFile file, code, (err) ->
                        throw err if err?
                        saved += 1
                        if saved == total
                            writeResponse self, options
                            callback?()

      # Get the code to save.
      @pack (packedCode) ->
          write(options.packed, packedCode) if options.packed?
          if options.minified?
                writeMinified = (minifiedCode) -> write options.minified, minifiedCode
                self.minify writeMinified, packedCode
