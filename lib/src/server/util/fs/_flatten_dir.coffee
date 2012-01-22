fs        = require 'fs'
fsPath    = require 'path'
fsCommon  = require './_common'

module.exports = 
  ###
  Flattens a directory structure to a set of file paths (deep).
  @param path: to the directory.
  @param options:
              - hidden:  : Flag indicating if hidden files or folders should be included (default true)
  @param callback: (err, paths)
  ###
  flattenDir: (path, options..., callback) ->
      # Setup initial conditions.
      options       = options[0] ?= {}
      includeHidden = options.hidden ?= true
      result        = []
      
      returnResult = () -> callback? null, result
      failed = (err) ->
            callback?(err) if err?
            err?
      
      # 1. Read the files.
      @readDir path, dirs:false, files:true, hidden:includeHidden, (err, files) =>
        return if failed(err)
        result.push file for file in files
        
        # 2. Walk sub directories.
        @readDir path, dirs:true, files:false, hidden:includeHidden, (err, dirs) =>
          return if failed(err)
          count = 0
          
          if dirs.length is 0
            # No directories, return now.
            returnResult()
          else
          
              # -- RECURSION --
              # NB: This is performed sequentually to avoid a 'too many files open' error.
              flattenChild = (index) =>
                dir = dirs[index]
                unless dir?
                  # Reached last dir, return now.
                  returnResult()
                  return
                
                @flattenDir dir, options, (err, paths) =>
                  return if failed(err)
                  
                  # Add child paths.
                  result.push file for file in paths
                  flattenChild index + 1 # <== RECURSION.
              
              flattenChild 0






