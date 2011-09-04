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


  ###
  Concatenates the specified set of files together and saves them
  to the file system.
  @param options:
            - paths:     Array of files to concatinate into the single file.
            - standard:  The path to save the uncompressed file to.
            - minified:  The path to save the compressed file to.
  @param callback invoked upon completion.
  ###
  save: (options = {}, callback) ->
      
      # Setup initial conditions.
      core  = require 'open.server'
      paths = options.paths
      
      # Determine total number of files being saved.
      total = 0
      total += 1 if options.standard?
      total += 1 if options.minified?
      if total is 0
          callback?() # No paths to save to.
          return
      
      # Concatenate the files.
      @files paths, (code) =>
          saved = 0
          onSaved = ->
              saved += 1
              callback?() if saved is total

          save = (data, toFile) ->
              unless toFile?
                  onSaved()
                  return
              core.util.fs.writeFile toFile, data, (err) ->
                      throw err if err?
                      onSaved()

          
          # Save the uncompressed file.
          if options.standard?
              save code, options.standard
          
          # Save the minified the code.
          if options.minified?
              minifiedCode = core.util.javascript.compress code
              minifiedCode = @headerComment(paths) + minifiedCode
              save minifiedCode, options.minified


