fs      = require 'fs'
version = require './version'


###
A wrapper around a node [package.json].
###
module.exports = class Package
  ###
  Constructor.
  @param path : The path or directory containing the package.
  ###
  constructor: (path) -> 
    # Format the path.
    path = _(path).trim()
    path = _(path).strLeft 'package.json'
    path = _(path).rtrim('/')
    path = "#{path}/package.json"
    @path = path
    
    # Load the data.
    @data = fs.readFileSync path, 'utf8'
    @data = JSON.parse @data.toString()
  
  
  ###
  Increments the version number.
  @param options 
            - save: Flag indicating if the package should be saved after incrementing the version (default: no).
  @returns the new version number.
  ###
  incrementVersion: (options = {}) -> 
    version.incrementPackage @data
    @saveSync() if (options.save ?= no) is yes
    @data.version
  
  
  ###
  Gets or sets the value of a dependnecy.
  @param name:    The name of the dependency.
  @param value:   Optional.  If specfied, the new value to assign.
  ###
  dependencyVersion: (name, value) -> 
    # Setup initial conditions.
    dependencies = @data.dependencies ?= {}
    
    # Find the matching dependnecy
    for key of dependencies
      if key is name
        if value?
          # Assign a new value
          dependencies[key] = value
        else
         # Read the current value
         value = dependencies[key]
        
        return value
    
    # Not found.
    null
  
  
  ###
  Saves the package to disk.
  ###
  saveSync: -> 
    str = JSON.stringify(@data, null, '\t')
    fs.writeFileSync @path, str, 'utf8'



  