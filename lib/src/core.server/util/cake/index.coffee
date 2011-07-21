fs = require 'fs'

packagePath = (packageDir) -> "#{packageDir}/package.json"

module.exports =
  version: require './version'

  ###
  Gets the package.json in the given directory
  @param dir: The directory the [package.json] file is in.
  ###
  readPackage: (dir) ->
      path = packagePath(dir)
      data = fs.readFileSync path, 'utf8'
      JSON.parse data.toString()

  ###
  Saves the given package to disk.
  @param package : {object} The package JSON.
  @param dir     : the directory of the package.
  ###
  savePackage: (package, dir) ->
      str = JSON.stringify(package, null, '\t')
      fs.writeFileSync packagePath(dir), str, 'utf8'



