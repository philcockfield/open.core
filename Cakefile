{exec} = require 'child_process'
core   = require './index'
log = core.util.log

logDone = -> log 'Done', color.green

buildLibs = (callback) -> 
    console.log 'Building all 3rd party lib code...'
    core.util.javascript.build.libs -> 
        console.log "See: #{core.paths.public}/libs"
        logDone()
        console.log ''
        callback?()
      

buildCore = (callback) -> 
  console.log 'Building all [open.core] client code...'
  core.util.javascript.build.all
      save: true
      callback: (result) ->
          console.log ' - Packed file:   ', result.paths.packed
          console.log ' - Minified file: ', result.paths.minified
          logDone()
          console.log ''
          callback?()

task 'specs', 'Run the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs/server', (err, stdout, stderr) ->
      console.log stdout + stderr

task 'build', 'Build and save all JavaScript files', ->
    buildLibs -> buildCore()

