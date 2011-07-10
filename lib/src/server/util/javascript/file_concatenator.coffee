fs  = require 'fs'
Seq = require 'seq'


###
Concatenates a list of files into a single file.
###
class FileConcatenator
  ###
  Constructor.
  @param paths - the array of paths to files to concatenate.
  ###
  constructor: (@paths) ->
      @paths = [@paths] if not _.isArray(@paths)




# Public members.

###
Creates a new instance of the class populated with the
files in the given folder.
@param path to the folder.
@param callback (err, instance)
###
FileConcatenator.fromFolder = (path, callback) ->
    Seq()
      .seq ->
        fs.readdir path, @
      .seq (files) ->
        files = (file for file in files when not _.startsWith(file, '.'))
        callback? new FileConcatenator(files)


# Export
module.exports = FileConcatenator
