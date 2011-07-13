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
  fsPath = require 'path'

  paths = core.paths
  serverPath = "#{paths.server}/core.server.coffee"
  fs = core.util.fs

  # fsPath.exists serverPath, (result) -> console.log 'Exists: ', result, serverPath
  # fsPath.exists serverPath + 1, (result) -> console.log 'Exists: ', result, serverPath + 1

  src = "#{paths.test}/foo_src2/"
  dst = "#{paths.test}/FOO"
  
  copyDir = -> fs.copy src, dst,
      mode:0777
      foo:123
      bar:456,
      (err) ->
        console.log 'DONE'
        console.log 'err:', err
        console.log ''
  copyDir()


  # fs.createDir "#{paths.test}/_TMP/foo/baz/thing", -> console.log 'DIR DONE'


