fs    = require 'fs'
util  = require 'util'


module.exports =
  concatenate: require './concatenate'


  ###
  Determines whether a file/folder exists at the specified location.
  @param path to the item to look at.
  @param callback to invoke upon complete.  Returns boolean.
  ###
  exists: (path, callback) ->
    fs.stat path, (err, stats) ->
        if err?
            if err.errno == 2
              callback false # Does not exist
            else
              throw err if err?
        else
            callback true # Exists


#  copydir: (source, destination, callback) ->
#    console.log 'src', source
#    console.log 'dst', destination
#    fs.mkdir "#{destination}/one/two", 0777, true, (err) ->


