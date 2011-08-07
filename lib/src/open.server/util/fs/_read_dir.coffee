fs        = require 'fs'
fsPath    = require 'path'
fsCommon  = require './_common'

###
Filters out a set of paths.
@param paths to filter
@param fnInclude(path, stats): determines if the path is be be included
@param callback(err, paths)
###
filterPaths = (paths, fnInclude, callback) ->
        count = 0
        result = []
        failed = false

        returnResult = -> callback?(null, result)
        returnResult() if paths.length is 0

        statRetrieved = (path, stats) ->
            return if failed
            count += 1
            result.push path if fnInclude?(path, stats)
            returnResult() if count == paths.length

        readStats = (path) ->
            fs.stat path, (err, stats) ->
                if err?
                    callback?(err)
                    failed = true
                    return
                else
                    statRetrieved path, stats

        readStats path for path in paths


filterPathsSync = (paths, fnInclude) ->
        result = []
        for path in paths
            stats = fs.statSync(path)
            result.push path if fnInclude?(path, stats)
        result   
    
    
getFlags = (options) -> 
        flags = 
            includeDirs:    options.dirs ?= true
            includeFiles:   options.files ?= true
            includeHidden:  options.hidden ?= true
            deep:           options.deep ?= false
        flags.isFiltered = not flags.includeDirs or not flags.includeFiles or not flags.includeHidden
        flags

dirFilter = (flags, path, stats) ->
        return false if not flags.includeHidden and fsCommon.isHidden(path)
        return false if not flags.includeDirs and stats.isDirectory()
        return false if not flags.includeFiles and stats.isFile()
        true



module.exports = 
  ###
  Retrieves the list of fully qualified file paths within the given directory.
  @param path: to the directory.
  @param options:
              - dirs        : Flag indicating if directories should be included (default: true)
              - files       : Flag indicating if files should be included (default:true)
              - hidden:     : Flag indicating if hidden files or folders should be included (default:true)
              - deep:       : Flag indicating if the entire child hierarchy should be traversed (default: false)
  @param callback: (err, paths)
  ###
  readDir: (path, options..., callback) ->
      # Setup initial conditions.
      self = @
      options = options[0] ?= {}
      flags = getFlags(options)

      failed = (err) ->
            callback?(err) if err?
            err?

      returnPaths = (files) ->
            callback? null, files

      read = (optionFlags) -> 
          fs.readdir path, (err, files) ->
              return if failed(err)
              files = fsCommon.expandPaths(path, files)

              unless optionFlags.isFiltered
                # Return the file list (unfiltered).
                returnPaths files
              else
                # A filter has been applied.  Narrow the return list.
                fnFilter = (path, stats) -> dirFilter(optionFlags, path, stats)
                filterPaths files, fnFilter, (err, filteredPaths) ->
                    return if failed(err)
                    returnPaths filteredPaths

      # Execution.
      if flags.deep is yes and flags.includeDirs
          # Deep read (-- RECURSION --).
          # 1. Read the current level without folders.
          self.readDir path, dirs:false, deep:false, files:options.files, hidden:options.hidden, (err, result) -> 
              return if failed(err)
        
              # 2. Read the contents of each folder, and fill the root return array.
              self.readDir path, dirs:true, deep:false, files:false, hidden:options.hidden, (err, folders) -> 
                  return if failed(err)
                  count = 0
                  onFolderRead = (paths) -> 
                          result = _.union(result, paths)
                          count += 1
                          returnPaths(result) if count is folders.length
                  
                  if folders.length is 0
                    returnPaths(result)
                  else
                      for folder in folders
                          result.push folder # 3a. Add the folder itself.
                          self.readDir folder, options, (err, paths) -> 
                              return if failed(err)
                              onFolderRead paths # 3b. Add each each child.

      else
          # Read the current level only.
          read(flags)
      
              
              



            
  ###
  Retrieves the list of fully qualified file paths within the given directory (synchronous).
  @param path: to the directory.
  @param options:
              - dirs        : Flag indicating if directories should be included (default: true)
              - files       : Flag indicating if files should be included (default:true)
              - hidden:     : Flag indicating if hidden files or folders should be included (default:true)
  @returns array of paths
  ###
  readDirSync: (path, options = {}) ->
      # Setup initial conditions.
      self = @
      flags = getFlags(options)
      
      files = fs.readdirSync path
      files = fsCommon.expandPaths(path, files)
      
      unless flags.isFiltered
        # Return the file list (unfiltered).
        return files
      else
        # A filter has been applied.  Narrow the return list.
        fnFilter = (path, stats) -> dirFilter(flags, path, stats)
        return filterPathsSync files, fnFilter
      