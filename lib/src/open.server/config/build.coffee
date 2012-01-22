core      = require '../../open.server'
Builder   = core.util.javascript.Builder
ModuleDef = core.util.ModuleDef


# Initialize the module builder system.
ModuleDef.registerPath core.paths.client
ModuleDef.defaults.header = core.copyright asComment:true


buildList =
  core:     false
  controls: true    # Include dependencies.
  auth:     false
  harness:  true    # Include dependencies.


module.exports = build = 
  ###
  Builds the entire set of client side scripts.
  @param callback: invoked upon completion (optional).
  ###
  all: (callback) -> 
    count = 0
    for key of buildList
      count += 1
      build[key] => 
        count -= 1
        callback?() if count is 0
  
  ###
  Compiles the 3rd party libs to the /public/javascripts/libs folder.
  @param callback: invoked upon completion.
  ###
  libs: (callback) ->
    # Setup initial conditions.
    module    = ModuleDef.find 'open.client/libs'
    targetDir = "#{core.paths.public}/javascripts/libs"
    
    # Save.
    module.save targetDir,
      includeRoot: false
      withLibs:    true
      -> 
        
        # Copy the [require.js] file.
        core.util.fs.copy "#{module.dir}/src/require.js", "#{targetDir}/require.js", -> 
        
        # Finish up.
        callback?()


# PRIVATE --------------------------------------------------------------------------


save = (name, options..., callback) -> 
  options = options[0] ? {}
  module = ModuleDef.find name
  throw "Cannot find module [#{name}]" unless module?
  module.save "#{core.paths.javascripts}/core", options, callback


# Initialize.
for key of buildList
  do (key) -> 
    build[key] = (callback) -> 
      save "open.client/#{key}", 
        withDependencies: buildList[key], 
        callback


