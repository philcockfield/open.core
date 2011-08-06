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
      self = @
      options = options[0] ?= {}
      includeHidden = options.hidden ?= true
      result = []

      returnResult = () -> callback? null, result
      failed = (err) ->
            callback?(err) if err?
            err?

      # 1. Read the files.
      self.readDir path, dirs:false, files:true, hidden:includeHidden, (err, files) ->
            return if failed(err)
            result.push file for file in files

            # 2. Walk sub directories.
            self.readDir path, dirs:true, files:false, hidden:includeHidden, (err, dirs) ->
                return if failed(err)
                count = 0

                if dirs.length is 0 #and files.length is 0
                    # No directories - return now.
                    returnResult()
                else

                    # -- Recursion --
                    for dir in dirs
                        self.flattenDir dir, options, (err, paths)->
                            return if failed(err)

                            # Add child paths and return.
                            result.push file for file in paths

                            # 3. Check if this the last directory.
                            count += 1
                            returnResult() if count == dirs.length
