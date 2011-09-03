fs           = require 'fs'
CoffeeScript = require 'coffee-script'

###
Represents a single javascript/coffee-script file, or a complete folder, to build.
###
module.exports = class BuildFile
  ###
  Constructor.
  @param path:      The path to the code file to build.
  @param namespace: The namespace the file resides within.
  ###
  constructor: (@path, @namespace) -> 
          
          # Setup initial conditions.
          @code         = {}
          @namespace    = BuildFile.formatNamespace(@namespace)
          @isJavascript = _(@path).endsWith '.js'
          @isCoffee     = _(@path).endsWith '.coffee'
          throw "File type not supported: #{@path}" if not @isJavascript and not @isCoffee
          
          # Store the extension.
          @extension = '.coffee' if @isCoffee
          @extension = '.js' if @isJavascript
          
          # Extract the file name (without extension).
          @name = @path
          @name = _(@name).strRightBack '/'
          @name = _(@name).strLeft @extension
          @id   = "#{@namespace}/#{@name}"
  
  ###
  An object containing built code strings.  This is populated via the 'build' method.
  - javascript:   The javascript (compiled from coffee-script if a .coffee file was specified)
  - coffeescript: The raw coffees-script value.
  ###
  code: undefined

  ###
  Flag indicating whether the file has been built (code has a value.)
  ###
  isBuilt: false
  
  ###
  Builds the code at the source path, storing the results
  in the 'code' property.
  @param callback(code, buildFile): Invoked when complete. 
                          Returns
                            - the 'code' property object.
                            - a reference to this BuildFile instance.
                        
  ###
  build: (callback) -> 
    fs.readFile @path, (err, data) =>
        throw err if err?
        data = data.toString()
    
        # Store code values.
        code = @code
        code.javascript = data if @isJavascript is yes
        if @isCoffee is yes
            code.coffeescript = data
            code.javascript = CoffeeScript.compile(data)
        
        # Compose the Common-JS module property.
        code.moduleProperty = """
                              "#{@id}": function(exports, require, module) {
                                #{code.javascript}
                              }
                              """
        # Finish up.
        @isBuilt = true
        callback? code, @


# Static methods.
BuildFile.formatNamespace = (ns) -> 
    return '' unless ns?
    _(ns).rtrim('/') if ns?
    
