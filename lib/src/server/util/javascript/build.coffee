fs = require 'fs'

module.exports =

  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  ###
  libs: (callback) ->
    core = require 'core.server'
    libs = "#{core.paths.public}/javascripts/libs"
    src = "#{libs}/src/"
    paths = [
      "#{src}/jquery-1.6.2.js"
      "#{src}/underscore-1.1.6.js"
      "#{src}/underscore.string-1.1.5.js"
      "#{src}/backbone-0.5.1.js"
    ]

    console.log "Saving lib files to: #{libs}"
    console.log '...'

    concat = new core.util.javascript.FileConcatenator(paths)
    options =
        paths: paths
        standard: "#{libs}/libs.js"
        minified: "#{libs}/libs-min.js"
    concat.save options, ->
        console.log 'Done'

