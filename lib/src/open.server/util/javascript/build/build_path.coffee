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
                    exclude:    A path, or array of paths, to exclude from building.
                                Relevant to folders only.
                                That path is relative to the folder 'path', for example:
                                  - '/lib', or
                                  - 'lib'   would exclude all files within {path}/lib/
                                Alternatively specific file(s) can be excluded, for example:
                                  - '/views/foo.coffee'
                 }
  ###
  constructor: (definition = {}) -> 
      
      # Setup initial conditions.
      @deep      = definition.deep ? true
      @path      = definition.path ? null
      @path      = _(@path).rtrim '/' if @path?
      @namespace = BuildFile.formatNamespace(definition.namespace)
      @code      = {}
      if @path?
          @isFile   = hasSupportedExtension @path
          @isFolder = not @isFile
      @deep    = false if @isFile
      @dir     = getDir @
      @exclude = formatExcludePaths @, ( definition.exclude ? [] )
  
  
  # The collection of [BuildFile]'s.
  files: []
  
  
  ###
  The collection of paths to exclude.  
    Paths are relative to the root [path].
    - '/lib', or
    - 'lib'   would exclude all files within {path}/lib/
  ###
  exclude: []
  
  
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


# PRIVATE --------------------------------------------------------------------------


hasExtension = (path, extension) => _(path).endsWith extension
hasSupportedExtension = (path) -> hasExtension(path, '.js') or hasExtension(path, '.coffee')
isExcluded = (buildPath, path) -> _(buildPath.exclude).any (p) -> _(path).startsWith(p)


getDir = (buildPath) -> 
  return buildPath.path if buildPath.isFolder
  if buildPath.path?
    path = _(buildPath.path)
    return path.strLeftBack '/' if path.include('/') 
  null


formatExcludePaths = (buildPath, exclude) -> 
  exclude = [exclude] unless _(exclude).isArray()
  exclude = _(exclude).map (path) -> 
    dir  = ''
    dir  = buildPath.dir + '/' if buildPath.dir?
    path = _(path).strRight(dir) if _(path).startsWith dir
    path = _(path).trim '/'
    path = dir + path


buildSingleFile = (buildPath, callback) -> 
  # Determine whether teh path has been excluded.
  path = buildPath.path
  if isExcluded buildPath, path
    callback []
    return
  
  # Build the file.
  buildFile = new BuildFile path, buildPath.namespace
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
      if index >= paths.length
        # All paths have been built.
        returnSorted()
        return
      
      # Get the path, and ensure it has not been excluded.
      path = paths[index]
      if isExcluded buildPath, path
        build index + 1  # <== RECURSION.
        return
      
      # Calcualte the namespace.
      ns = _(path).strRight buildPath.path
      ns = _(ns).strLeftBack '/'
      ns = buildPath.namespace + ns
      
      # Run the file-builder.
      (new BuildFile path, ns).build (code, buildFile) -> 
          files.push buildFile
          build index + 1  # <== RECURSION.
    
    build 0





