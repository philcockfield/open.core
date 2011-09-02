fs = require 'fs'

###
Represents a single path to to a javascript/coffee-script file, or folder, to build.
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
      
      # Set path-type flags.
      if @source?
          @isJavascript = _(@source).endsWith '.js'
          @isCoffee     = _(@source).endsWith '.coffee'
          @isFolder     = not @isJavascript and not @isCoffee
          @isFile       = not @isFolder
      @deep = false if @isFile
      
  ###
  The built code.  This is populated via the 'build' method.
  ###
  code: { }
  
  ###
  Builds the code at the source path, storing the results
  in the 'code' property.
  @param callback(code): Invoked when complete. Returns the 'code' property object.
  ###
  build: (callback) -> 
    
    # Setup initial conditions.
    self = @
    
    # Load the code file.
    if @isFile is yes
      fs.readFile @source, (err, data) ->
          throw err if err?
          code = data.toString()
    
          if self.isJavascript is yes
            self.code.javascript = code
            callback? self.code
            return
        
        
    
    
  