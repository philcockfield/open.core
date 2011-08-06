fs          = require 'fs'
util        = require 'util'
fsPath      = require 'path'
fsCommon    = require './_common'
fsCreateDir = require './_create_dir'

createDir = fsCreateDir.createDir

###
Performs a deep copy of a directory, and all it's contents.
Special purpose method used by the more general [copy] method.

@param source:      path to directory to copy.
@param target:      path to copy to.
@param options:
            - mode: copy code (defaults to 0777 for Read-Write for users/groups, Read-Only world).
@param callback: (err)
###
copyDir = (source, target, options..., callback) ->

  # Setup initial conditions.
  self = @
  options = options[0] ?= {}
  mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT # Read-Write for users/groups, Read-Only world.

  # Sanitize the paths.
  source      = fsCommon.cleanDirPath(source)
  target      = fsCommon.cleanDirPath(target)

  # 1. Ensure the target directory exists.
  createDir target, options, (err) ->
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
 Module
###
module.exports = 
  ###
  Copies a file or directory to a new location, creating the
  target directory if it does not already exist.
  @param source:    path the file/directory to copy.
  @param target:    path to copy to.
  @param options:
              - mode      : copy code (defaults to 0777 - see: FILE_MODE.DEFAULT).
              - overwrite : flag indicating if an existing file should be overwritten (default false).
  @param callback: (err)
  ###
  copy: (source, target, options..., callback) ->
      throw "source not valid to copy: '#{source}'" unless _.isString(source)
      throw "target not valid to copy: '#{target}'" unless _.isString(target)
      
      # Setup initial conditions.
      self = @
      options = options[0] ?= {}
      mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT
      overwrite = options.overwrite ?= false

      prepareDir = (file, onComplete) ->
            dir = fsPath.dirname(file)
            createDir dir, options, (err) ->
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
              - mode: copy code (defaults to 0777).
              - overwrite : flag indicating if an existing file should be overwritten (default false).
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

