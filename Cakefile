{exec} = require 'child_process'

task 'specs', 'Runs the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs', (err, stdout, stderr) ->
      console.log stdout + stderr

