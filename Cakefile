{exec}   = require 'child_process'
core     = require './index'
log      = core.util.log
cakeUtil = core.util.cake
onExec   = core.util.onExec

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
          console.log ' - Standard file: ', result.paths.standard
          console.log ' - Minified file: ', result.paths.minified
          logDone()
          console.log ''
          callback?()


task 'specs', 'Run the Jasmine BDD specs', ->
  exec 'jasmine-node --color --coffee test/specs/server', (err, stdout, stderr) ->
      console.log stdout + stderr


task 'build', 'Build and save all JavaScript files', ->
    buildLibs -> 
      buildCore()


task 'bump', 'Increments the package version and re-publishes to NPM', -> 
    
    # Setup initial conditions.
    console.log 'Bumping version...'
    package = new cakeUtil.Package(core.paths.root)
    
    # Increment the package version.
    increment = (callback) -> 
        package.incrementVersion save:yes
        log ' - Version incremented to: ' + package.data.version, color.blue
        callback?()
    
    # Check in to git.
    checkin = (callback) -> 
        log ' - Checking into GitHub', color.blue
        console.log ''
        git = core.util.git
        
        # 1. Stage the [package.json] file
        git.exec 'git add package.json', (err, stdout, stderr) ->
            onExec err, stdout, stderr
        
            # 2. Commit.
            git.exec "git commit -m 'Version bump: #{package.data.version}'", (err, stdout, stderr) ->
                onExec err, stdout, stderr
            
                # 3. Push to GitHub.
                git.exec 'git push origin', (err, stdout, stderr) ->
                    onExec err, stdout, stderr
                    callback?()
    
    # Publish to NPM.
    publish = (callback) -> 
        console.log ' - Publishing to NPM registry...'
        exec 'npm publish', (err, stdout, stderr) ->
            console.log stdout + stderr
            callback?()
    
    # Execute.
    increment -> checkin -> publish -> logDone()
