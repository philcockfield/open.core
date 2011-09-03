fs           = require 'fs'
CoffeeScript = require 'coffee-script'

###
Represents a single javascript/coffee-script file, or a complete folder, to build.
###
module.exports = class BuildFile
  ###
  Constructor.
  @param filePath:  The path to the code file to build.
  @param namespace: The namespace the file resides within.
  ###
  constructor: (@filePath, @namespace) -> 
          
          # Setup initial conditions.
          @code         = {}
          @namespace    = _(@namespace).rtrim('/') if @namespace?
          @isJavascript = _(@filePath).endsWith '.js'
          @isCoffee     = _(@filePath).endsWith '.coffee'
          throw "File type not supported: #{@filePath}" if not @isJavascript and not @isCoffee
          
          # Store the extension.
          @extension = '.coffee' if @isCoffee
          @extension = '.js' if @isJavascript
          
          # Extract the file name (without extension).
          @name = @filePath
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
  Builds the code at the source path, storing the results
  in the 'code' property.
  @param callback(code): Invoked when complete. Returns the 'code' property object.
  ###
  build: (callback) -> 
    fs.readFile @filePath, (err, data) =>
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
        callback? code
    