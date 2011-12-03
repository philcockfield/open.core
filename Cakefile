{exec}   = require 'child_process'
core     = require './index'
log      = core.util.log
tasks    = core.util.tasks
onExec   = core.util.onExec
git      = core.util.git

logDone = -> log 'Done', color.green



task 'specs', 'Run the server-side Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs/server', (err, stdout, stderr) ->
      console.log stdout + stderr

option '-t', '--throw', 'Throw an exception if any client specs fail'
task 'specs:client', 'Run the client-side Jasmine BDD specs in a new process on the server', (options) ->
  runner = new core.util.testing.ClientTestRunner
                                        app:  'app.js'
                                        port: 8888
                                        path: '/specs'
  runner.run -> 
      if options.throw is yes and runner.passed is no
          throw "#{runner.totalFailed} of #{runner.total} client side unit tests failed."
      callback?()


task 'build', 'Build and save all JavaScript files', ->
  timer = new core.util.Timer()
  buildLibs -> 
    buildCore -> 
      log 'Built in:', color.blue, "#{timer.secs()} seconds"
      log()


task 'css:images', "Converts all the core images into Data-URI's for use as Stylus constants", -> 
  sourceDir  = core.paths.images
  targetFile = "#{core.paths.stylesheets}/core/images.styl"
  tasks.css.toDataUris sourceDir, targetFile


task 'bump', 'Increments the package version and re-publishes to NPM', -> 
  # Setup initial conditions.
  log 'Bumping version...', color.blue
  log()
  version = 'x.x.x'
  clientPath = "#{core.paths.client}/core/index.coffee"
  
  # Increments version references.
  increment = (callback) -> 
    tasks.increment 
      rootPath:   core.paths.root
      clientPath: clientPath
      (ver) -> 
        version = ver
        callback?()
  
  # Check in to git.
  checkin = (callback) -> 
    log '+ Checking into GitHub', color.blue
    log()
    git = core.util.git
    
    # 1. Stage the [package.json] file
    git.exec "git add package.json; git add #{clientPath}", (err, stdout, stderr) ->
      onExec err, stdout, stderr
      
      # 2. Commit.
      git.exec "git commit -m 'Version bump: #{version}'", (err, stdout, stderr) ->
        onExec err, stdout, stderr
        
        # 3. Push to GitHub.
        git.exec 'git push origin', (err, stdout, stderr) ->
          onExec err, stdout, stderr
          callback?()

  # Publish to NPM.
  publish = (callback) -> 
    console.log '+ Publishing to NPM registry...'
    exec 'npm publish', (err, stdout, stderr) ->
      console.log stdout + stderr
      callback?()
  
  # Execute.
  increment -> checkin -> publish -> logDone()


task 'deploy', 'Deploys to Heroku', -> 
  log 'Deploying', color.blue, 'to Heroku...'
  git.exec 'git push heroku master', (err, stdout, stderr) ->
    onExec err, stdout, stderr
    logDone()


# PRIVATE --------------------------------------------------------------------------


buildLibs = (callback) -> 
  console.log 'Building all 3rd party lib code...'
  core.util.javascript.build.libs -> 
    log ' - See: ', color.blue, "#{core.paths.public}/libs"
    logDone()
    log()
    callback?()

buildCore = (callback) -> 
  console.log 'Building all [open.core] client code...'
  core.util.javascript.build.all -> 
    log ' - See: ', color.blue, "#{core.paths.public}/core"
    logDone()
    log()
    callback?()


