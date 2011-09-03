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
  Gets the collection of build modules.
  ###
  modules: []

  
  ###
  Builds the code at the source path, storing the results in the 'modules' property.
  @param callback(modules): Invoked when complete. 
                            Returns the 'modules' collection.
  ###
  build: (callback) -> 
    
    # Reset the modules collection.
    @modules = []

    if @isFile is yes
        # Build the single code file.
        buildFile = new BuildFile(@source)
        buildFile.build => 
            
            # Add the built code file to the modules collection.
            @modules.push buildFile
            callback? @modules
    
    else if @isFolder
        console.log 'FOLDER' # TEMP 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  