core    = require 'open.server'
fs      = require 'fs'
fsUtil  = require './fs'
Builder = require './javascript/build/builder'


###
Represents an MVC [module.json] definition.
###
module.exports = Def = class ModuleDef
  # Properties (set in constructor).
  name:         undefined   # The unique namespace/name of the module.
  dependencies: []          # Array of modules that this module is depenent upon.
  
  ###
  Constructor.
  @param path: Path to the directory containig the [module.json] file, 
               or an explicit .json file path.
  ###
  constructor: (path) -> 
    
    # Format the path.
    path = _(path).trim()
    unless _(path).endsWith('.json')
      path = _(path).rtrim('/') + '/module.json'
    @path = path
    @dir = _(path).strLeftBack '/'
    
    # Load the data.
    try
      file = fs.readFileSync(path).toString()
      file = JSON.parse file
    catch error
      throw new Error "Failed to parse module definition.\nModule path: #{path}.\nError: #{error.message}"
    
    # Copy properties.
    for prop of file
      @[prop] = file[prop]
    @file ?= @name
    
    # Ensure required properties exist.
    unless @name?
      throw new Error "A module must have a name.\nModule path: #{path}"
    
    # Add the dependency resolving method.
    @dependencies.resolve = => 
      result = []
      
      # Build list of immediate dependencies.
      for name in @dependencies
        continue if name is @name # Don't allow self-references.
        dep = Def.find(name)
        if dep?
          result.push dep
        else
          throw new Error """
                          The module dependency [#{name}] was not found. 
                          Module path: #{path}
                          Hint: Ensure that all paths have registered with the static [ModuleDef.registerPaths()] method.       
                          """
      
      # Build the complete flat list of dependencies from the entire tree.
      all = []
      exists      = (name)     -> _(all).any (m) -> m.name is name 
      existsInSet = (depNames) -> _(depNames).any (name) -> exists(name)
      add = (deps) =>
        # all.push deps
        for module in deps
          isRoot = module.name is @name
          
          # Don't insert the current module as a dependency of itself
          # and don't insert anything twice
          unless exists(module.name) or isRoot
            all.push module
            
            # Walk down the tree (if this item has not already been added).
            unless existsInSet(module.dependencies)
              add module.dependencies.resolve()  # <== RECURSION.
      add result
      all = _(all).sortBy (m) -> m.name
      
      # Finish up.
      result.all = all
      result
  
  
  ###
  Creates a new JavaScript [Builder] for the module.
  @param options:  
      Builder options - see [Builder] constructor.
      NB: Defaults of these can be set as static properties on [ModuleDef.defaults]
        - includeRequireJS:  Flag indicating if the CommonJS require script should be included (default: false).
        - header:            Optional. A notice to prepend to the head of the code (eg. a copyright notice).
        - minify:            Optional. Flag indicating if code should be minified.  Default true.
      
      - includeDependencies: Flag indicating if paths to dependencies should be included (default true).
      - includeRoot:         Flag indicating if the root path to the module should be included.
                             Use this to build dependencies only (default true).
  @returns a new [Builder].
  ###
  builder: (options = {}) -> 
    
    # Setup initial conditions.
    defaults = Def.defaults
    
    # - Module defaults.
    options.includeDependencies ?= defaults.includeDependencies
    options.includeRoot         ?= defaults.includeRoot
    
    # - Builder defaults.
    options.includeRequireJS    ?= defaults.includeRequireJS
    options.header              ?= defaults.header
    options.minify              ?= defaults.minify
    
    # Build the set of paths.
    paths = []
    addPath = (module) -> 
      paths.push 
        path:       module.dir
        namespace:  module.name
        deep:       true 
    
    addPath @ if options.includeRoot is yes
    
    if options.includeDependencies is yes
      addPath dep for dep in @dependencies.resolve().all
    
    # Construct the builder.
    builder = new Builder(paths, options)
  
  
  ###
  Builds and saves the code.
  @param dir:             The directory to save the file to (the file name is within the [module.json]).
  @param options:         Builder options.  See 'builder' method.
  @param callback(code):  Invoked up completion.
  ###
  save: (dir, options..., callback) -> 
    options = options[0] ? {}
    @builder(options).save dir:dir, name:@file, callback


# STATIC --------------------------------------------------------------------------

# Default values.
Def.defaults =
  includeRequireJS:    false
  header:              null
  minify:              true
  includeDependencies: false
  includeRoot:         true

# Collection of modules.
Def.modules = []


# Resets the static collection of registered modules.
Def.reset = -> Def.modules = []


###
Finds the registered module from the static collection
with the given name.
@param name: The name of the module.
@returns the matching module definition, otherwise null
###
Def.find = (name) -> _(Def.modules).find (m) -> m.name is name


###
Finds all modules within the given folder and
adds them to the [modules] static collection.
@param dir: Path to the directory to look within.
###
Def.registerPath = (dir) -> 
  
  # Get the set of [module.json] files anywhere within the given folder.
  files = fsUtil.readDirSync dir, dirs:false, files:true, hidden:false, deep:true
  files = _(files).filter (f) -> _(f).endsWith 'module.json'
  
  pathExists = (path) -> _(Def.modules).any (m) -> m.path is path
  withName   = (def)  -> _(Def.modules).filter (m) -> m.name is def.name
  
  # Create each module definition.
  for path in files
    continue if pathExists(path) # This folder has already been registered.
    def = new Def(path)
    
    # Ensure the name is unique.
    existing = withName def
    if existing.length > 0
      
      paths = ''
      for item in existing
        paths += "- #{item.path}\n"
      throw new Error """
                      A module with the name '#{def.name}' has already been registered. 
                      Module paths: 
                      - #{path}
                      #{paths}
                      """
    # Add to collection.
    Def.modules.push def
  
  
