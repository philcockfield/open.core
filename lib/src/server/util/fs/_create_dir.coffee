fs        = require 'fs'
fsPath    = require 'path'
fsCommon  = require './_common'


module.exports = 
  ###
  Safely creates a a directory structure to the given location.
  Note: If the directly already exists no changes are made.
  @param path: of the directory to create.
  @param options:
              - mode: copy code (defaults to 0777 - see: DEFAULT_FILE_MODE).
  @param callback: (err)
  ###
  createDir: (path, options..., callback) ->
      self = @
      options = options[0] ?= {}
      mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT

      # Recursive create operation.
      create = (dir, onCreated) ->
          dir = fsCommon.cleanDirPath(dir)

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
                    # It was probably because the folder does not exist,
                    # attempt to create it's parent.
                    create fsCommon.parentDir(dir), ->
                        # Now the parent exists, retry creating this directory.
                        create dir, -> onCreated?()

      # Start the create operation.
      create path, -> callback?()


  ###
  (Synchronous) Safely creates a a directory structure to the given location.
  Note: If the directly already exists no changes are made.
  @param path: of the directory to create.
  @param options:
              - mode: copy code (defaults to 0777 - see: DEFAULT_FILE_MODE).
  @returns True if the directory was created, or False if it already existed.
  ###
  createDirSync: (path, options = {}) -> 
      self = @
      mode = options.mode ?= fsCommon.FILE_MODE.DEFAULT

      # Recursive create operation.
      create = (dir) ->
          dir = fsCommon.cleanDirPath(dir)
          
          # 1. Check if the directory already exists.
          if fsCommon.existsSync(dir)
            return false
          else
            # 2. Attempt to create the directory.
            try
                fs.mkdirSync dir, mode
                return true
            catch error
                # 3. -- RECURSION --
                # Failed to create the directory.
                # It was probably because the folder does not exist,
                # attempt to create it's parent.
                if create fsCommon.parentDir(dir)
                    # Now the parent exists, retry creating this directory.
                    return create dir
                else
                    return false
                
      # Start the create operation.
      create path
              
            

            
            

            
            
            
        
