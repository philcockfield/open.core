fs  = require 'fs'

core = null

###
Concatenates a list of files into a single file.
###
class FileConcatenator
  ###
  Constructor.
  @param paths - the array of paths to files to concatenate.
  ###
  constructor: (@paths) ->
      core = require 'core.server'
      @paths = [@paths] if not _.isArray(@paths)



  save: (options = {}, callback)->
      core.util.fs.concatenate.files options.paths, (code) ->
          saved = 0
          onSaved = ->
              saved += 1
              callback?() if saved == 2

          save = (data, toFile) ->
              unless toFile?
                  onSaved()
                  return
              fs.writeFile toFile, data, (err) ->
                      throw err if err?
                      onSaved()

          save code, options.standard
          core.util.javascript.compress code, (min)-> save min, options.minified


# Export
module.exports = FileConcatenator
