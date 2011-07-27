module.exports = 
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
  Common error codes
  ###
  ERROR: 
    NOT_EMPTY: 'ENOTEMPTY'