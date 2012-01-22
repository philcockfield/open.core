core   = require '../../../open.server'
fs     = require 'fs'
fnCode = require('../javascript/_common').codeFunction


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
  files: (paths, callback) ->
    loaded = 0
    files = _(paths).map (path)-> { path: path }
    
    loadComplete = () =>
      code = ''
      for file in files
          code += "#{file.data.toString()}\n\n\n"
      callback? @headerComment(paths) + code
    
    load = (index) -> 
      file = files[index]
      unless file?
        # Last file ha been loaded.
        loadComplete()
        return
      
      fs.readFile file.path, (err, data) ->
        throw err if err?
        file.data = data
        load index + 1 # <== RECUSION.
    
    load 0
  
  
  ###
  Concatenates the specified set of files together and saves them
  to the file system.
  @param options:
            - paths:     Array of files to concatinate into the single file.
            - minified:  Flag indicating if a minified version should be made (default true).
  @param callback(code)  Invoked upon completion.
                            Return value is is a [Function] with two properties:
                              - standard: the uncompressed code.
                              - minified: the compressed code.
                            The function can be invoked like so:
                              fn(minified):
                                - minified: true  - returns the compressed code.
                                - minified: false - returns the uncompressed code.
  ###
  toCode: (options = {}, callback) -> 
    
    # Setup initial conditions.
    paths = options.paths ? []
    if paths.length is 0
      callback? fnCode(null, null)
      return
    
    # Concatenate the files.
    @files paths, (code) =>
      
      # Minify the code if required.
      minifiedCode = null
      if options.minified ? true
          minifiedCode = core.util.javascript.compress code
          minifiedCode = @headerComment(paths) + minifiedCode
      
      # Finish up.
      callback? fnCode(code, minifiedCode)
  
  
  ###
  Concatenates the specified set of files together and saves them
  to the file system.
  @param options:
            - paths:     Array of files to concatinate into the single file.
            - standard:  The path to save the uncompressed file to.
            - minified:  The path to save the compressed file to.
  @param callback(code): Invoked upon completion.
  ###
  save: (options = {}, callback) ->
    # Setup initial conditions.
    paths = options.paths
    
    # Determine total number of files being saved.
    total = 0
    total += 1 if options.standard?
    total += 1 if options.minified?
    if total is 0
        callback? fnCode(null, null) # No paths to save to.
        return
    
    # Load the code.
    @toCode paths:paths, minified:options.minified?, (code) -> 
      
        saved = 0
        onSaved = ->
            saved += 1
            callback?(code) if saved is total
        
        save = (data, toFile) ->
            unless toFile?
                onSaved()
                return
            core.util.fs.writeFile toFile, data, (err) ->
                    throw err if err?
                    onSaved()
        
        # Save the uncompressed file.
        if options.standard?
            save code.standard, options.standard
        
        # Save the minified the code.
        if options.minified?
            save code.minified, options.minified


