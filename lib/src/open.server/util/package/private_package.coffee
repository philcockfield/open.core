JsonFile = require '../json_file'


###
A wrapper around a node [package.private.json] file used for deploying
private module dependencies to hosting services like Heroku.
###
module.exports = class PrivatePackage extends JsonFile
  ###
  Constructor.
  @param path : The path or directory containing the [package.private.json] file.
  ###
  constructor: (path) -> 
    super path, 'package.private.json'
