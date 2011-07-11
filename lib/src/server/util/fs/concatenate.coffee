fs  = require 'fs'
Seq = require 'seq'


module.exports =
  ###
  Creates a comment header list the given set of files
  with their paths removed.
  @param files: array of file paths
  ###
  headerComment: (files) ->
        text = '/* \n'
        for key of files
            text += "  - #{_(key).strRightBack('/')}\n" if key?
        text += '*/\n\n\n'

  ###
  Concatenates the given files to a single string.
  @param paths - the array of paths to files to concatenate.
  @param callback (err, instance)
  ###
  files: (paths, callback)->
      self = @
      Seq(paths)
        .seqEach (file) ->
            fs.readFile file, this.into(file)
        .seq () ->
            code = ''
            for key of @vars
                code += "#{@vars[key].toString()}\n\n\n"
            callback? self.headerComment(@vars) + code


  ###
  Concatenates all the files in the given folder to a single string.
  @param path to the folder.
  @param callback (data)
  ###
  folder: (path, callback) ->
    self = @
    Seq()
      .seq ->
          fs.readdir path, @
      .seq (files) ->
          # Remove hidden items and append paths.
          files = (file for file in files when not _.startsWith(file, '.'))
          files = _(files).map (item) -> path + item

          # Pass execution to the 'files' method.
          self.files files, callback


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
