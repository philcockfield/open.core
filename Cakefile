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


task 'build:client', 'Packages all Open.Core client-code into files', ->
  console.log 'Building all client-code into files...'
  core.util.javascript.build.client
      save: true
      callback: (result) ->
          console.log 'Done'
          console.log 'result', result
          console.log ' - Packed file:   ', result.paths.packed
          console.log ' - Minified file: ', result.paths.minified
          console.log ''




# =======================

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
  # copyDir()


  # fs.createDir "#{paths.test}/_TMP/foo/baz/thing", -> console.log 'DIR DONE'

  files = [
    { path: "#{dst}/hello.txt", data:'Hello1' }
    { path: "#{dst}/hello2.txt", data:'Hello2' }
  ]

  fs.writeFiles files, (err) ->
        console.log 'Created Folder'
        throw err if err?

        fs.deleteDir dst, (err) ->
            console.log 'DELETED'
            console.log 'err:', err
            console.log ''


task 'temp:del', ->
  fs = core.util.fs
  path = "#{core.paths.test}/FOO"
  fs.createDir path, ->
        fs.deleteDir path, (err) ->
            console.log 'DELETED'
            console.log 'err:', err
            console.log ''





