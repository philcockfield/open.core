{exec} = require 'child_process'

task 'specs', 'Runs the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs', (err, stdout, stderr) ->
      console.log stdout + stderr



task 'killall', 'Kills all running node processes', ->

  exec 'ps -ef|grep node', (err, stdout, stderr) ->
      console.log stdout + stderr
