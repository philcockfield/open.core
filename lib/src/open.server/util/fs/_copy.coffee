fs          = require 'fs'
util        = require 'util'
fsPath      = require 'path'
fsCommon    = require './_common'
fsCreateDir = require './_create_dir'
fsReadDir   = require './_read_dir'

createDir     = fsCreateDir.createDir
createDirSync = fsCreateDir.createDirSync
readDirSync   = fsReadDir.readDirSync


toCopyList = (files, source, target) -> 
    _(files).map (file) ->
            item =
                source:   "#{source}/#{file}"
                target:   "#{target}/#{file}"


boundsCheck = (source, target) -> 
      throw "Cannot copy. 'source' not valid to copy: '#{source}'" unless _.isString(source)
      throw "Cannot copy. 'target' not valid to copy: '#{target}'" unless _.isString(target)


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
  mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT 

  # Sanitize the paths.
  source  = fsCommon.cleanDirPath(source)
  target  = fsCommon.cleanDirPath(target)

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
                files = toCopyList(files, source, target)
                module.exports.copyAll files, options, (err) ->
                      if err?
                          callback?(err)
                          return # Failed - exit out completely.
                      else
                          callback?(err) # Done.


copyDirSync = (source, target, options = {}) ->
      # Setup initial conditions.
      self = @
      mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT 

      # Sanitize the paths.
      source  = fsCommon.cleanDirPath(source)
      target  = fsCommon.cleanDirPath(target)

      # 1. Ensure the target directory exists.
      createDirSync target, options

      # 2. Get the files.
      files = fs.readdirSync source
      return if files.length == 0
  
      # 3. Copy each file (at this level).
      files = toCopyList(files, source, target)
      module.exports.copyAllSync files, options



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
              - mode                : copy code (defaults to 0777 - see: FILE_MODE.DEFAULT).
              - overwrite           : flag indicating if an existing file should be overwritten (default false).
              - filter(sourcePath)  : Function to filter items out with. 
                                      Return true to copy the item, otherwise False to ignore.
  @param callback: (err)
  ###
  copy: (source, target, options..., callback) ->
      
    # Setup initial conditions.
    boundsCheck(source, target)
    self      = @
    options   = options[0] ?= {}
    mode      = options.mode ?= fsCommon.FILE_MODE.DEFAULT
    overwrite = options.overwrite ?= false
    filter    = options.filter
    
    # Check whether the file is to be filtered out.
    if _(filter).isFunction()
      unless filter(source)
        callback?()
        return
    
    prepareDir = (file, onComplete) ->
          dir = fsPath.dirname(file)
          createDir dir, options, (err) ->
                unless err?
                  onComplete() # Success.
                else
                  callback(err)
                  return # Failed - exit out completely.
    
    # The final copy operation.
    copyFile = ->
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
                    copyFile()
                else
                    # 2c. Check whether the target file already exists
                    #    and if so don't overwrite it.
                    fsPath.exists target, (exists) ->
                          if exists
                              callback?()
                              return # File exists - do nothing.
                          else
                            # 3. File does not exist - copy it now.
                            copyFile()


  ###
  Copies a file or directory to a new location, creating the
  target directory if it does not already exist (synchronously).
  @param source:    path the file/directory to copy.
  @param target:    path to copy to.
  @param options:
              - mode                : copy code (defaults to 0777 - see: FILE_MODE.DEFAULT).
              - overwrite           : flag indicating if an existing file should be overwritten (default false).
              - filter(sourcePath)  : Function to filter items out with. 
                                      Return true to copy the item, otherwise False to ignore.
  ###
  copySync: (source, target, options = {}) -> 
    # Setup initial conditions.
    boundsCheck source, target
    self      = @
    mode      = options.mode ?= fsCommon.FILE_MODE.DEFAULT
    overwrite = options.overwrite ?= false
    filter    = options.filter
    
    # Check whether the file is to be filtered out.
    if _(filter).isFunction()
      return unless filter(source)
    
    # The final copy operation.
    copyFile = -> 
      # Ensure the target directory exists.
      dir = fsPath.dirname(target)
      createDirSync dir, options
      
      # Perform the file copy operation.
      data = fs.readFileSync(source)
      fs.writeFileSync target, data
    
    # 1. Check whether the source is a directory.
    stats = fs.statSync(source)
    if stats.isDirectory()
      # 2a. Copy the directory.
      copyDirSync source, target, options
    else
      if overwrite
        # 2b. Copy - overwriting any existing file.
        copyFile()
      else
        # 2c. Check whether the target file already exists
        #    and if so don't overwrite it.
        if not fsCommon.existsSync(target)
          
          # 3. File does not exist - copy it now.
          copyFile()

  
  ###
  Copies a collection of files/folders to a new location providing a
  single callback when complete.
  See the [copy] method for more information.
  @param items:  Array of file descriptors.  Each descriptor is an object
                 containing the following structure:
                 [
                   { source:'/foo/bar.txt',   target:'/baz/thing.txt' }
                   { source:'/folder',        target:'/folder_new' }
                 ]
  @param options:
              - mode                : copy code (defaults to 0777).
              - overwrite           : flag indicating if an existing file should be overwritten (default false).
              - filter(sourcePath)  : Function to filter items out with. 
                                      Return true to copy the item, otherwise False to ignore.
  @param callback: (err)
  ###
  copyAll: (items, options..., callback) ->
    options = options[0] ?= {}
    copied  = 0
    failed  = false
    
    onComplete = (err) -> 
      return if failed
      failed = true if err?
      callback? err
      
    # NB: Copy sequentially to avoid a 'too many files open' error.
    copyFile = (index) =>
      return if failed
      
      # Check if the last file has been reached.
      file = items[index]
      unless file?
        onComplete()
        return
      
      @copy file.source, file.target, options, (err) ->
          if err?
            onCopied err # Failure.
          else
            copyFile index + 1 # Success.
    copyFile 0
  
  
  ###
  Copies a collection of files/folders to a new location (synchronously).
  See the [copySync] method for more information.
  @param items:  Array of file descriptors.  Each descriptor is an object
                 containing the following structure:
                 [
                   { source:'/foo/bar.txt',   target:'/baz/thing.txt' }
                   { source:'/folder',        target:'/folder_new' }
                 ]
  @param options:
              - mode                : copy code (defaults to 0777).
              - overwrite           : flag indicating if an existing file should be overwritten (default false).
              - filter(sourcePath)  : Function to filter items out with. 
                                      Return true to copy the item, otherwise False to ignore.
  ###
  copyAllSync: (items, options = {}) ->
      for file in items
        @copySync file.source, file.target, options



