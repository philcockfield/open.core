fsUtil    = require '../../fs'
BuildFile = require './build_file'


###
Represents a path to a javascript/coffee-script file, or a complete folder, to build.
###
module.exports = class BuildPath
  ###
  Constructor.
  @param definition: The definition of the path to build.
                 {
                    path:       The path to a folder or single file.
                    namespace:  The CommonJS namespace the source files reside within.
                    deep:       Flag indicating if the child tree of a folder should be recursed (default: true).
                 }
  ###
  constructor: (definition = {}) -> 
      
      # Setup initial conditions.
      @deep      = definition.deep ?= true
      @path      = definition.path ?= null
      @namespace = BuildFile.formatNamespace(definition.namespace)
      @code      = {}
      
      # Set path-type flags.
      if @path?
          # @isFile   = hasExtension('.js') or hasExtension('.coffee')
          @isFile   = hasSupportedExtension @path
          @isFolder = not @isFile
      @deep = false if @isFile

  
  ###
  Gets the collection of [BuildFile]'s.
  ###
  files: []

  
  ###
  Builds the code at the source path, storing the results in the 'files' property.
  @param callback(files): Invoked when complete. 
                            Returns the 'files' collection.
  ###
  build: (callback) -> 
    
    # Reset the [files] collection.
    @files = []
    
    returnFiles = (files) -> 
        @files = files
        callback? files

    if @isFile is yes
        buildSingleFile @, (files) => returnFiles files
    
    else if @isFolder
        buildFilesInFolder @, (files) => returnFiles files

  ###
  Determines whether the code for the path has been built.
  ###
  isBuilt: -> 
    return false unless @files?.length > 0
    not _(@files).any (m) -> m.isBuilt == false



# PRIVATE
hasExtension = (path, extension) => _(path).endsWith extension
hasSupportedExtension = (path) -> 
    hasExtension(path, '.js') or hasExtension(path, '.coffee')


buildSingleFile = (buildPath, callback) -> 
        buildFile = new BuildFile buildPath.path, buildPath.namespace
        buildFile.build => 
            
            # Add the built code file to the [files] collection.
            files = buildPath.files
            files.push buildFile
            callback files


buildFilesInFolder = (buildPath, callback) -> 
        
        # Setup initial conditions.
        files = buildPath.files
        
        returnSorted = -> 
            files = _(files).sortBy (item) -> item.id
            callback files
        
        # Build all files in the folder.
        options =
              files:  true
              dirs:   false
              hidden: false
              deep:   buildPath.deep
        
        # Get the complete list of files to build.
        fsUtil.readDir buildPath.path, options, (err, paths) -> 
            throw err if err?
            
            # Ensure only supported files types are included.
            paths = _(paths).map (p) -> p if hasSupportedExtension(p)
            paths = _(paths).compact()
            
            # Build each file.
            # NB: Each file built sequentially to avoid a 'Too many open files' error.
            index = 0
            count = paths.length
            
            build = (index) -> 
                # Get the path.
                path = paths[index]
                
                # Calcualte the namespace.
                ns = _(path).strRight buildPath.path
                ns = _(ns).strLeftBack '/'
                ns = buildPath.namespace + ns
                
                # Run the file-builder.
                (new BuildFile path, ns).build (code, buildFile) -> 
                      files.push buildFile
                      
                      if index < paths.length - 1
                        build index + 1
                      else
                        # Finish if all paths have been built.
                        returnSorted()
            
            build 0
