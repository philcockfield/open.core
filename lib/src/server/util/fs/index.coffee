fs      = require 'fs'
util    = require 'util'
fsPath  = require 'path'

notFoundError = (err) -> err.errno == 2
cleanDirPath = (path) ->
                path = _.trim(path)
                path = _.rtrim(path, '/')
                path


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
  Reads the list of fully qualified file paths within the given directory.
  @param path: to the directory.
  @param options:
              - expandPaths: Flag indicating if paths should be expanded (default: true)
              - {Futures: filter out hidden files, and directories}
  @param callback: (err, paths)
  ###
  readDir: (path, options..., callback) ->
      self = @
      options = options[0] ?= {}
      expandPaths = options.expandPaths ?= true

      fs.readdir path, (err, files) ->
          if err?
              callback?(err)
              return
          files = self.expandPaths(path, files) if expandPaths
          callback? null, files


  ###
  Performs a deep copy of a directory, and all it's contents.
  @param source:      path to directory to copy.
  @param destination: path to copy to.
  @param options:
              - mode: copy code (defaults to 0777 for full permissions).
  @param callback: (err)
  ###
  copyDir: (source, destination, options..., callback) ->

    # Setup initial conditions.
    self = @
    options = options[0] ?= {}
    mode = options.mode ?= 0777

    # Sanitize the paths.
    source      = cleanDirPath(source)
    destination = cleanDirPath(destination)

    # 1. Ensure the target directory exists.
    self.createDir destination, options, (err) ->
        if err?
            callback?(err)
            return
        else
            # 2. Get the files.
            self.readDir source, expandPaths: false, (err, files) ->
                if err? or files.length == 0
                    callback?(err)
                    return
                else
                  # 3. Copy each file (at this level).
                  files = _(files).map (file) ->
                          item =
                              source:      "#{source}/#{file}"
                              destination: "#{destination}/#{file}"

                  self.copyAll files, options, (err) ->
                        if err?
                            callback?(err)
                            return # Failed - exit out completely.
                        else
                            callback?(err) # Done.


  ###
  Copies a collection of files/folders to a new location.
  if that does not already exist.
  @param items:  Array of file descriptors.  Each descriptor is an object
                 containing the following structure:
                 [
                   { source:'/foo/bar.txt', destination:'/baz/thing.txt' }
                   { source:'/folder', destination:'/folder_new' }
                 ]
  @param options:
              - mode: copy code (defaults to 0777 for full permissions).
  @param callback: (err)
  ###
  copyAll: (items, options..., callback) ->
    self = @
    copied = 0
    failed = false

    onCopied = (file) ->
          return if failed
          copied += 1
          callback?() if copied >= items.length

    for file in items
        self.copy file.source, file.destination, options, (err) ->
            unless err?
              onCopied(file) # Success.
            else
              failed = true
              callback?(err) # Failure.
              return


  ###
  Copies a file or directory to a new location, creating the
  target directory if it does not already exist.
  @param source:      path the file/directory to copy.
  @param destination: path to copy to.
  @param options:
              - mode: copy code (defaults to 0777 for full permissions).
  @param callback: (err)
  ###
  copy: (source, destination, options..., callback) ->
      self = @

      prepareDir = (file, onComplete) ->
            dir = fsPath.dirname(file)
            self.createDir dir, options, (err) ->
                  unless err?
                    onComplete() # Success.
                  else
                    callback(err)
                    return # Failed - exit out completely.

      # 1. Check whether the source is a directory.
      fs.stat source, (err, stats) ->
          if err?
              callback?(err)
              return # Failed - exit out completely.
          else
              if stats.isDirectory()
                  # 2a. Copy the directory.
                  self.copyDir source, destination, options, (err) -> callback?()
              else
                  # 2b. Check whether the destination file already exists
                  #    and if so don't overwrite.
                  fsPath.exists destination, (exists) ->
                        if exists
                            callback?()
                            return
                        else
                            # 3. Ensure the target directory exists.
                            prepareDir destination, ->

                                # 4. Perform the file copy operation.
                                reader = fs.createReadStream(source)
                                writer = fs.createWriteStream(destination)
                                util.pump reader, writer, (err) ->
                                      callback?(err)


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
