core    = require '../../../server'
Package = require '../package/package'


###
Increments the version of the library.
@param options
       - rootPath:    The path to the root of the app where the [package.json] file is to be found.
       - clientPath:  The path to the client-side [index] that contains a 'version:' property to update.
       - silent:      Flag indicating if output should be written to the console (default false).
@returns the new version.
###
module.exports = (options = {}, callback) -> 
  
  # Setup initial conditions.
  log        = core.log
  fsUtil     = core.util.fs
  rootPath   = options.rootPath
  clientPath = options.clientPath
  throw new Error('Failed to increment version. [rootPath] not provided.') unless rootPath?
  
  # Increment the [package.json] file.
  pkg = new Package(rootPath)
  pkg.incrementVersion save:yes
  version = pkg.data.version
  
  # Increment the core library.
  if clientPath?
    
    # Open the file and replace the version.
    file = fsUtil.fs.readFileSync clientPath
    file = file.toString()
    file = file.replace /version:\s*'[\d\.]*'/g, "version: '#{version}'"
    
    # Save the file.
    fsUtil.writeFileSync clientPath, file
  
  # Finish up.
  unless options.silent is yes
    log "Version of [#{pkg.data.name}] incremented to:", color.blue, version
    log 'Files changed:', color.blue
    log ' - ' + pkg.path
    log ' - ' + clientPath if clientPath?
    log()
  callback? version
  
  
  
  
