fs  = require 'fs'

module.exports =
  ###
  Creates a comment header list the given set of files
  with their paths removed.
  @param files: array of file paths
  ###
  headerComment: (files) ->
        text = '/* \n'
        for file in files
            text += "  - #{_(file).strRightBack('/')}\n" if file?
        text += '*/\n\n\n'

  ###
  Concatenates the given files to a single string.
  @param paths - the array of paths to files to concatenate.
  @param callback(code) to invoke upon completion.  Passes the single file content.
  ###
  files: (paths, callback)->
      loaded = 0
      files = _(paths).map (path)-> { path: path }

      loadComplete = () =>
            code = ''
            for file in files
                code += "#{file.data.toString()}\n\n\n"
            callback? @headerComment(paths) + code

      load = (file) ->
        fs.readFile file.path, (err, data) ->
              throw err if err?
              file.data = data
              loaded += 1
              loadComplete() if loaded == paths.length
      load file for file in files






#      self = @
#      Seq(paths)
#        .seqEach (file) ->
#            fs.readFile file, this.into(file)
#        .seq () ->
#            code = ''
#            for key of @vars
#                code += "#{@vars[key].toString()}\n\n\n"
#            callback? self.headerComment(@vars) + code


  ###
  Concatenates the specified set of files together and saves them
  to the file system.
  @param options:
            - paths:    Array of files to concatinate into the single file.
            - standard: The path to save the uncompressed file to.
            - minified: The path to save the compressed file to.
  @param callback invoked upon completion.
  ###
  save: (options = {}, callback)->
      core = require 'core.server'
      core.util.fs.concatenate.files options.paths, (code) ->
          saved = 0
          onSaved = ->
              saved += 1
              callback?() if saved == 2

          save = (data, toFile) ->
              unless toFile?
                  onSaved()
                  return
              fs.writeFile toFile, data, (err) ->
                      throw err if err?
                      onSaved()

          save code, options.standard
          core.util.javascript.compress code, (min)-> save min, options.minified
