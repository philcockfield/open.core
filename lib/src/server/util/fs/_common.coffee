fs     = require 'fs'
fsPath = require 'path'


module.exports = 
  # Constants
  FILE_MODE:
      DEFAULT: 0o0777 # Full permissions.
  ERROR: 
      NOT_EMPTY: 'ENOTEMPTY'
      NOT_EXIST: 'ENOENT'    # No such file or directory.
    

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
  Cleans a directory path trimming white space and any trailing '/' char.
  @param path to clean.
  ###
  cleanDirPath: (path) -> 
        path = _.trim(path)
        path = _.rtrim(path, '/')
        path

  
  ###
  Determine whether or not the given path exists.
  @param path           : The path to test for.
  @param callback(bool) : Callback that is invoked with yes/no result.
  ###
  exists: fsPath.exists
  
  ###
  Determine whether or not the given path exists (synchronous).
  @param path       : The path to test for.
  @returns boolean  : Yes if the path exists, otherwise No.
  ###
  existsSync: (path) -> 
      try
        stat = fs.statSync(path)
        return true
      catch error
        return false
        
      
  ###
  Gets the parent directory from the specified path
  @param path to examine
  @returns the parent part of the path or null.
  ###
  parentDir: (path) ->
      # Setup initial conditions.
      return unless path?
      path = @cleanDirPath(path)

      # Split the path.
      path = _.strLeftBack(path, '/')
      return null if path == ''
      path

  
