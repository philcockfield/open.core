fs       = require 'fs'
fsUtil   = require '../fs'
JsonFile = require '../json_file'


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
  Sets up symbolic links for each dependent module
  that has been installed locally.
  
  To make a module available for linking, from it's folder
  execute:
  
      npm link
      
  This will publish a symbolic link to it within the global
  modules folder.
  ###
  link: -> 
    # Ensure the modules directory exists.
    createModulesDir @
    
    # Enumerate each dependnecy.
    for item in @data.dependencies
      sourcePath = "#{@linkDir}/#{item.name}"
      targetPath = "#{@modulesDir}/#{item.name}"
      
      # Ensure the source module exists.
      continue unless fsUtil.existsSync sourcePath
      
      # Delete the existing directory or link (if there is one).
      if fsUtil.existsSync targetPath
        stats = fs.lstatSync targetPath
        
        if stats.isSymbolicLink()
          fs.unlinkSync targetPath
        else
          fsUtil.deleteSync targetPath, force:true
      
      # Setup the sumbolic link.
      fs.symlinkSync sourcePath, targetPath


# PRIVATE --------------------------------------------------------------------------


createModulesDir = (package) -> fsUtil.createDirSync package.modulesDir


