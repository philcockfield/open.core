fs = require 'fs'

module.exports =

  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  ###
  libs: (callback) ->
    core = require 'core.server'
    libs = "#{core.paths.public}/javascripts/libs"
    srcLibs = "#{libs}/src"

    saved = 0
    save = (script, toFile) ->
              fs.writeFile toFile, script, (err) ->
                      throw err if err?
                      saved += 1
                      callback?() if saved == 2

    compiler = new core.util.javascript.Compiler(srcLibs)
    compiler.build false, (script) -> save script, "#{libs}/libs.js"
    compiler.build true, (script) -> save script, "#{libs}/libs-min.js"

