BuildPath = require './build_path'

###
Stitches together a set of javascript/coffee-script files
into modules that are addressable via CommonJS [require] calls.
###
module.exports = class Builder
  ###
  Constructor.
  @param paths: An array of objects specify the code files to build.
                  The array item object takes the form:
                  [
                     {
                        path:      The path to a folder or single file.
                        namespace:  The CommonJS namespace the source files reside within.
                        deep:       Flag indicating if the child tree of a folder should be recursed (default: true).
                     }
                  ]
  @param options
      - includeRequire: Flag indicating if the CommonJS require script should be included (default: false).
  
  ###
  constructor: (paths = [], options = {}) -> 

      # Setup initial conditions.
      paths = [paths] unless _.isArray(paths)
      @includeRequire = options.includeRequire ?= false
      options.build ?= false
      
      # Convert paths to wrapper classes.
      @paths = _(paths).map (path) -> new BuildPath(path)

  
  ###
  Gets the built code.  This is populated after the [build] method has completed.
  ###
  code: undefined
  
  ###
  Gets or sets whether the code has been built.
  True after the [build] method has completed.
  ###
  isBuilt: false
  
  
  ###
  Builds the code.
  @param callback(code): Invoked upon completion. Returns the 'code' property value.
  ###
  build: (callback) -> 
    
    
    