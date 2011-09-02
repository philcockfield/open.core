
###
Represents a single path to to a JavaScript/CoffeeScipt file, or folder, to build.
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
        @isCoffee = _(@source).endsWith '.coffee'
        @isFolder = not @isJavascript and not @isCoffee
        
