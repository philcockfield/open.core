{exec} = require 'child_process'
core = require './index'


task 'specs', 'Run the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs/server', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'build:libs', 'Build and save the 3rd party libs to /public', ->
  core.util.javascript.build.libs()


task 'build:core', 'Packages all Open.Core client-code into files', ->
  console.log 'Building all client-code into files...'
  core.util.javascript.build.client
      save: true
      callback: (result) ->
          console.log 'Done'
          console.log ' - Packed file:   ', result.paths.packed
          console.log ' - Minified file: ', result.paths.minified
          console.log ''

