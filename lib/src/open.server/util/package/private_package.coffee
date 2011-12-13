fs       = require 'fs'
fsUtil   = require '../fs'
JsonFile = require '../json_file'
common   = require '../common'
log      = common.log

###
A wrapper around a node [package.private.json] file used for deploying
private module dependencies to hosting services like Heroku.
###
module.exports = class PrivatePackage extends JsonFile
  ###
  Constructor.
  @param path : The path or directory containing the [package.private.json] file.
  ###
  constructor: (path) -> 
    super path, 'package.private.json'
    @modulesDir = "#{@dir}/node_modules.private"
  
  
  ###
  The path to the directory that NPM stores symbolic link references 
  to linked modules within.
  ###
  linkDir: "#{process.installPrefix}/lib/node_modules"
  
  
  ###
  Sets up symbolic links for each dependent module that has
  been installed locally within the [node_modules.private] folder.
  
  To make a module available for linking, from it's folder
  execute:
  
      npm link
      
  This will publish a symbolic link to it within the global
  modules folder.
  ###
  link: -> 
    # Setup initial conditions.
    dependencies = @data.dependencies
    if dependencies?.length > 0
      log 'Linking private packages:', color.blue
    else
      log 'No private packages to link', color.red
      return
    
    # Ensure the modules directory exists.
    createModulesDir @
    
    # Enumerate each dependnecy.
    for item in dependencies
      log " ├─ #{item.name}", color.blue
      paths = dependencyPaths @, item
      
      # Ensure the source module exists.
      unless fsUtil.existsSync paths.source
        log '    ├─ Not found.  ', color.red, 'To link, run "npm link" in the dependency\'s folder.'
        continue
      
      # Delete the existing directory or link.
      deleteLink paths.target, linkOnly:false
      
      # Setup the sumbolic link.
      fs.symlinkSync paths.source, paths.target
      log '    ├─ Linked from:', color.green, paths.source
      log '    ├─ Linked to:  ', color.green, paths.target
    
    # Finish up.
    log()
  
  
  ###
  Removes link within the [node_modules.private]
  ###
  unlink: -> 
    # Setup initial conditions.
    dependencies = @data.dependencies
    if dependencies?.length > 0
      log 'Unlinking private packages:', color.blue
    else
      log 'No private packages to unlink', color.red
      return
    
    # Enumerate each dependnecy.
    for item in dependencies
      log " ├─ #{item.name}", color.blue
      paths      = dependencyPaths @, item
      targetPath = paths.target
      
      # Ensure the source module exists.
      unless fsUtil.existsSync targetPath
        log '    ├─ Nothing to unlink.  ', color.red
        continue
      
      # Delete the link.
      if deleteLink(targetPath, linkOnly:true)
        log '    ├─ Removed link from:', color.green, targetPath
      else
        log '    ├─ Not removed (not a linked folder):', color.red, targetPath
    
    # Finish up.
    log()

# PRIVATE --------------------------------------------------------------------------


createModulesDir = (package) -> fsUtil.createDirSync package.modulesDir

deleteLink = (path, options = {}) -> 
  return unless fsUtil.existsSync path
  stats = fs.lstatSync path
  if stats.isSymbolicLink()
    fs.unlinkSync path
  else
    return false if options.linkOnly is yes
    fsUtil.deleteSync path, force:true 
  
  true
  

dependencyPaths = (package, item) -> 
  paths =
    source: "#{package.linkDir}/#{item.name}"
    target: "#{package.modulesDir}/#{item.name}"



