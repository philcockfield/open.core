fs           = require 'fs'
CoffeeScript = require 'coffee-script'
BuildFile    = require './build_file'

###
Represents a path to a javascript/coffee-script file, or a complete folder, to build.
###
module.exports = class BuildPath
  ###
  Constructor.
  @param definition: The definition of the path to build.
                         {
                            source:     The path to a folder or single file.
                            namespace:  The CommonJS namespace the source files reside within.
                            deep:       Flag indicating if the child tree of a folder should be recursed (default: true).
                         }
  ###
  constructor: (definition = {}) -> 
      
      # Setup initial conditions.
      @deep      = definition.deep ?= true
      @source    = definition.source ?= null
      @namespace = definition.namespace ?= null
      @code      = {}
      
      # Set path-type flags.
      hasExtension = (extension) => _(@source).endsWith extension
      if @source?
          @isFile   = hasExtension('.js') or hasExtension('.coffee')
          @isFolder = not @isFile
      @deep = false if @isFile
      
  ###
  An object containing built code strings.  This is populated via the 'build' method.
  - javascript:   The javascript (compiled from coffee-script if a .coffee file was specified)
  - coffeescript: The raw coffees-script value.
  ###
  code: undefined
  
  ###
  Builds the code at the source path, storing the results
  in the 'code' property.
  @param callback(code): Invoked when complete. Returns the 'code' property object.
  ###
  build: (callback) -> 
    
    if @isFile is yes
        # Load the code file.
        new BuildFile(@source).build (code) => 
            _.extend @code, code
            callback? @code
    
    else if @isFolder
        console.log 'FOLDER' # TEMP 
        
        
    
    
  