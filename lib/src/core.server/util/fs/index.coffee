fs      = require 'fs'
util    = require 'util'
fsPath  = require 'path'

# CONSTANTS
ERROR =
  NOT_FOUND: 2
  NOT_EMPTY: 66


# PRIVATE MEMBERS
notFoundError = (err) -> err.errno == ERROR.NOT_FOUND
cleanDirPath = (path) ->
                path = _.trim(path)
                path = _.rtrim(path, '/')
                path

###
Performs a deep copy of a directory, and all it's contents.
-- Special purpose method used by the more general [copy] method. --

@param source:      path to directory to copy.
@param target:      path to copy to.
@param options:
            - mode: copy code (defaults to 0777 for full permissions).
@param callback: (err)
###
copyDir = (source, target, options..., callback) ->

  # Setup initial conditions.
  self = @
  options = options[0] ?= {}
  mode = options.mode ?= 0777

  # Sanitize the paths.
  source      = cleanDirPath(source)
  target      = cleanDirPath(target)

  # 1. Ensure the target directory exists.
  module.exports.createDir target, options, (err) ->
      if err?
          callback?(err)
          return
      else
          # 2. Get the files.
          fs.readdir source, (err, files) ->
              if err? or files.length == 0
                  callback?(err)
                  return
              else
                # 3. Copy each file (at this level).
                files = _(files).map (file) ->
                        item =
                            source:   "#{source}/#{file}"
                            target:   "#{target}/#{file}"

                module.exports.copyAll files, options, (err) ->
                      if err?
                          callback?(err)
                          return # Failed - exit out completely.
                      else
                          callback?(err) # Done.


###
Deletes a directory.
@param the path to the directory to delete.
@param options (optional)
        - force: Flag indicating if the directory should be deleted
                 if it contains content (default: true).
@param callback: (err)
###
deleteDir = (path, options..., callback) ->
    options = options[0] ?= {}
    force = options.force ?= true
    fs.rmdir path, (err) ->
        if err?
          if err.errno == ERROR.NOT_EMPTY and force
            require('rimraf')(path, callback)
          else
            callback?(err)
        else
          callback?() # Success.


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




###
Module Exports
###
module.exports =
  concatenate: require './concatenate'


  ###
  Prepends the given path on the array of files.
  @param path to prepend
  @param files to be prepended
  @returns an array with the fully expanded paths.
  ###
  expandPaths: (path, files = []) ->
      return files unless path?
      path = _.rtrim(path, '/')
      _(files).map (file) -> "#{path}/#{file}"


  ###
  Determines whether the specified path is hidden.
  @param path to examine.
  @return boolean
  ###
  isHidden: (path) ->
      return false unless path?
      path = _.strRightBack(path, '/')
      _.startsWith(path, '.')

  ###
  Retrieves the list of fully qualified file paths within the given directory.
  @param path: to the directory.
  @param options:
              - dirs        : Flag indicating if directories should be included (default: true)
              - files       : Flag indicating if files should be included (default:true)
              - hidden:     : Flag indicating if hidden files or folders should be included (default:true)
  @param callback: (err, paths)
  ###
  readDir: (path, options..., callback) ->

      # Setup initial conditions.
      self = @
      options = options[0] ?= {}

      # Determine filters.
      includeDirs = options.dirs ?= true
      includeFiles = options.files ?= true
      includeHidden = options.hidden ?= true
      isFiltered = not includeDirs or not includeFiles or not includeHidden

      failed = (err) ->
            callback?(err) if err?
            err?

      returnPaths = (files) ->
            callback? null, files

      fnFilter = (path, stats) ->
            return false if not includeHidden and self.isHidden(path)
            return false if not includeDirs and stats.isDirectory()
            return false if not includeFiles and stats.isFile()
            true

      fs.readdir path, (err, files) ->
          return if failed(err)
          files = self.expandPaths(path, files)

          unless isFiltered
            # Return the file list (unfiltered).
            returnPaths files
          else

            # A filter has been applied.  Narrow the return list.
            filterPaths files, fnFilter, (err, filteredPaths) ->
                return if failed(err)
                returnPaths filteredPaths



  ###
  Flattens a directory structure to a set of file paths (deep).
  @param path: to the directory.
  @param options:
              - hidden:  : Flag indicating if hidden files or folders should be included
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



  ###
  Deletes either file/directory at the specified path.
  @param the path to the file/directory to delete.
  @param options (optional)
          - force: Flag indicating if a directory should be deleted
                   if it contains content (default: true).
  @param callback: (err)
  ###
  delete: (path, options..., callback) ->
      options = options[0] ?= {}
      fs.stat path, (err, stats) ->
          if err?
              callback?(err)
              return # Failed.
          else
            if stats.isDirectory()
              deleteDir path, options, callback
            else
              fs.unlink path, (err) -> callback?(err)


  ###
  Copies a collection of files/folders to a new location providing a
  single callback when complete.
  See the [copy()] method for more information.
  @param items:  Array of file descriptors.  Each descriptor is an object
                 containing the following structure:
                 [
                   { source:'/foo/bar.txt',   target:'/baz/thing.txt' }
                   { source:'/folder',        target:'/folder_new' }
                 ]
  @param options:
              - mode: copy code (defaults to 0777 for full permissions).
              - overwrite : flag indicating if an existing file should be overwritten.
  @param callback: (err)
  ###
  copyAll: (items, options..., callback) ->
    self = @
    options = options[0] ?= {}
    copied = 0
    failed = false

    onCopied = (file) ->
          return if failed
          copied += 1
          callback?() if copied >= items.length

    for file in items
        self.copy file.source, file.target, options, (err) ->
            unless err?
              onCopied(file) # Success.
            else
              failed = true
              callback?(err) # Failure.
              return


  ###
  Copies a file or directory to a new location, creating the
  target directory if it does not already exist.
  @param source:    path the file/directory to copy.
  @param target:    path to copy to.
  @param options:
              - mode      : copy code (defaults to 0777 for full permissions).
              - overwrite : flag indicating if an existing file should be overwritten.
  @param callback: (err)
  ###
  copy: (source, target, options..., callback) ->
      self = @
      options = options[0] ?= {}
      mode = options.mode ?= 0777
      overwrite = options.overwrite ?= false

      prepareDir = (file, onComplete) ->
            dir = fsPath.dirname(file)
            self.createDir dir, options, (err) ->
                  unless err?
                    onComplete() # Success.
                  else
                    callback(err)
                    return # Failed - exit out completely.

      # The final copy operation.
      _copyFile = ->
            # Ensure the target directory exists.
            prepareDir target, ->
                  # Perform the file copy operation.
                  reader = fs.createReadStream(source)
                  writer = fs.createWriteStream(target, mode:mode)
                  util.pump reader, writer, (err) -> callback?(err)




      # 1. Check whether the source is a directory.
      fs.stat source, (err, stats) ->
          if err?
              callback?(err)
              return # Failed - exit out completely.
          else
              if stats.isDirectory()
                  # 2a. Copy the directory.
                  copyDir source, target, options, (err) ->
                            if err?
                              callback?(err)
                              return # Failed - exit out completely.

                            callback?()
              else
                  if overwrite
                      # 2b. Copy - overwriting any existing file.
                      _copyFile()
                  else
                      # 2c. Check whether the target file already exists
                      #    and if so don't overwrite it.
                      fsPath.exists target, (exists) ->
                            if exists
                                callback?()
                                return # File exists - do nothing.
                            else
                              # 3. File does not exist - copy it now.
                              _copyFile()


  ###
  Safely creates a a directory structure to the given location.
  Note: If the directly already exists no changes are made.
  @param path: of the directory to create.
  @param options:
              - mode: copy code (defaults to 0777 for full permissions).
  @param callback: (err)
  ###
  createDir: (path, options..., callback) ->
      self = @
      options = options[0] ?= {}
      mode = options.mode ?= 0777

      # Recursive create operation.
      create = (dir, onCreated) ->
          dir = cleanDirPath(dir)

          # 1. Check if the directory already exists.
          fsPath.exists dir, (exists) ->
              if exists
                  callback?()
                  return

              # 2. Attempt to create the directory.
              fs.mkdir dir, mode, (err) ->
                  unless err?
                    onCreated?() # Success.
                  else
                    # 3. -- RECURSION --
                    # Failed to create the directory.
                    # If it was probably because the folder does not exist
                    # attempt to create it's parent.
                    parent = self.parentDir(dir)
                    create parent, ->
                        # Not the parent exists, retry creating this directory.
                        create dir, -> onCreated?()

      # Start the create operation.
      create path, -> callback?()


  ###
  Gets the parent directory from the specified path
  @param path to examine
  @returns the parent part of the path or null.
  ###
  parentDir: (path) ->

      # Setup initial conditions.
      return unless path?
      path = cleanDirPath(path)

      # Split the path.
      path = _.strLeftBack(path, '/')
      return null if path == ''
      path


  ###
  Writes the data to the specified path (creating the containing folder if required).
  @param path: of the file to write to.
  @param data: to write
  @param options (optional):
              - encoding: defaults to 'utf8'
  @param callback: (err)
  ###
  writeFile: (path, data, options..., callback) ->
      # Setup initial conditions.
      options = options[0] ?= {}
      encoding = options.encoding ?= 'utf8'

      # 1. Ensure the directory exists.
      dir = fsPath.dirname(path)
      @createDir dir, (err) ->
          if err?
              callback?(err)
              return # Failed - exit out.
          else
              # 2. Write the file.
              fs.writeFile path, data, encoding, callback


  ###
  Writes the collection of file to disk providing a single
  callback when complete.
  @param files: An array of files definitions taking the following form:
                [
                  {
                    path:     '/path/to/write/to',
                    data:     {the data to write},
                  }
                ]
  @param options (optional) - See 'writeFile' method
  @param callback: (err)
  ###
  writeFiles: (files, options..., callback) ->
       self = @
       failed = false
       loaded = 0

       onWritten = ->
          return if failed
          loaded += 1
          callback?() if loaded == files.length

       for file in files
          @writeFile file.path, file.data, (err) ->
            if err?
                failed = true
                callback?(err)
                return # Failed.
            else
              onWritten()

