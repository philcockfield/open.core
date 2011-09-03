fs           = require 'fs'
CoffeeScript = require 'coffee-script'

buildFile = (buildPath, callback) -> 
      fs.readFile buildPath.source, (err, data) =>
          throw err if err?
          data = data.toString()
          
          # Store code values.
          code = buildPath.code
          code.javascript = data if buildPath.isJavascript is yes
          if buildPath.isCoffee is yes
              code.coffeescript = data
              code.javascript = CoffeeScript.compile(data)

          # Finish up.
          callback()


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
      @code      = {}
      
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
  code: {}
  
  ###
  Builds the code at the source path, storing the results
  in the 'code' property.
  @param callback(code): Invoked when complete. Returns the 'code' property object.
  ###
  build: (callback) -> 
    
    # Load the code file.
    if @isFile is yes then buildFile @, => callback? @code
    else if @isFolder
      console.log 'FOLDER' # TEMP 
        
        
    
    
  