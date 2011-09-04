fsUtil    = require '../../fs'
BuildFile = require './build_file'


buildSingleFile = (buildPath, callback) -> 
        buildFile = new BuildFile buildPath.source, buildPath.namespace
        buildFile.build => 
            
            # Add the built code file to the modules collection.
            modules = buildPath.modules
            modules.push buildFile
            callback modules

buildFilesInFolder = (buildPath, callback) -> 
        
        # Setup initial conditions.
        modules = buildPath.modules

        returnSorted = -> 
            modules = _(modules).sortBy (item) -> item.id
            callback modules
        
        # Build all files in the folder.
        options =
              files:  true
              dirs:   false
              hidden: false
              deep:   buildPath.deep
        
        # Get the complete list of files to build.
        fsUtil.readDir buildPath.source, options, (err, paths) -> 
            throw err if err?
            count = 0
            build = (path) -> 
                
                # Calcualte the namespace.
                ns = _(path).strRight buildPath.source
                ns = _(ns).strLeftBack '/'
                ns = buildPath.namespace + ns
                
                # Run the file-builder.
                (new BuildFile path, ns).build (code, buildFile) -> 
                      modules.push buildFile
                      count += 1
                      returnSorted() if count is paths.length
            build path for path in paths



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
      @namespace = BuildFile.formatNamespace(definition.namespace)
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
    
    returnModules = (modules) -> 
        @modules = modules
        callback? modules

    if @isFile is yes
        buildSingleFile @, (modules) => returnModules modules
    
    else if @isFolder
        buildFilesInFolder @, (modules) => returnModules modules

  ###
  Determines whether the path has been built.
  ###
  isBuilt: -> 
    return false unless @modules?.length > 0
    not _(@modules).any (m) -> m.isBuilt == false
