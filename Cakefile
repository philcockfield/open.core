{exec} = require 'child_process'
core = require './index'


task 'specs', 'Run the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'kill', 'Kill all running node processes', ->
  exec 'killall node', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'build:libs', 'Build and save the 3rd party libs to /public', ->
  core.util.javascript.build.libs()


task 'temp', 'Temp', ->

  paths     = core.paths
  path = "#{paths.server}/core.server.coffee"

  core.util.fs.exists path, (result) ->
    console.log 'result', result