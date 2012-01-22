fs        = require 'fs'
rimraf    = require 'rimraf'
fsCommon  = require './_common'

ERROR = fsCommon.ERROR



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
    
    # Attempt to delete the directory normally.
    fs.rmdir path, (err) ->
        if err?
          if err.code == ERROR.NOT_EMPTY and force
              # Force delete.
              rimraf path, (err) -> callback?(err)
          else
              callback?(err)
        else
            callback?() # Success.

          
###
Deletes a directory.
@param the path to the directory to delete.
@param options (optional)
        - force: Flag indicating if the directory should be deleted
                 if it contains content (default: true).
###
deleteDirSync = (path, options = {}) ->
    force = options.force ?= true
    try
        fs.rmdirSync path
    catch error
        if error.code == ERROR.NOT_EMPTY and force
            # Force delete.
            rimraf.sync path


###
Module
###
module.exports = 
  ###
  Deletes either file/directory at the specified path.
  @param the path to the file/directory to delete.
  @param options (optional)
          - force: Flag indicating if a directory should be deleted
                   if it contains content (default: true).
  @param callback: (err)
  ###
  delete: (path, options..., callback) ->
      self = @
      options = options[0] ?= {}
      fs.stat path, (err, stats) ->
          if err?
            switch err.code
              when ERROR.NOT_EXIST then callback?() # Ignore error (expected).
              else callback?(err) # Failed.
            return 
          else
            if stats.isDirectory()
              deleteDir path, options, callback
            else
              fs.unlink path, (err) -> callback?(err)


  ###
  Deletes either file/directory at the specified path.
  @param the path to the file/directory to delete.
  @param options (optional)
          - force: Flag indicating if a directory should be deleted
                   if it contains content (default: true).
  ###
  deleteSync: (path, options = {}) -> 
      try
        stats = fs.statSync path
        if stats.isDirectory()
          deleteDirSync path, options
        else
          fs.unlinkSync path
      catch error
          switch error.code
            when ERROR.NOT_EXIST then # Ignore error (expected).
            else throw error


          
        
      
          








