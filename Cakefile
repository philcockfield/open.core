{exec} = require 'child_process'
core = require './index'


task 'specs', 'Runs the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'kill', 'Kills all running node processes', ->
  exec 'killall node', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'build:libs', 'Builds and saves the 3rd party libs files', -> 


  
