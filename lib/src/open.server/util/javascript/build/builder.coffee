core      = require 'open.server'
fsUtil    = require '../../fs'
BuildPath = require './build_path'
minifier  = require '../minifier'
fnCode    = require('../_common').codeFunction

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
      - includeRequireJS:  Flag indicating if the CommonJS require script should be included (default: false).
      - header:            Optional. A notice to prepend to the head of the code (eg. a copyright notice).
      - minify:            Optional. Flag indicating if code should be minified.  Default true.
  
  ###
  constructor: (paths = [], options = {}) -> 
    
    # Setup initial conditions.
    paths             = [paths] unless _.isArray(paths)
    @includeRequireJS = options.includeRequireJS ?= false
    @header           = options.header ?= null
    @minify           = options.minify ?= true
    @code             = {}
    
    # Convert paths to wrapper classes.
    paths = _(paths).map (path) -> new BuildPath(path)
    paths = _(paths).sortBy (p) -> p.namespace
    @paths = paths
  
  
  ###
  Gets the built code.  This is populated after the [build] method has completed.
    It is a [Function] with two properties:
      - standard: the uncompressed code.
      - minified: the compressed code.
    The function can be invoked like so:
      fn(minified):
        - minified: true  - returns the compressed code.
        - minified: false - returns the uncompressed code.
  ###
  code: undefined
  
  
  ###
  Gets the set of files.
  ###
  files: -> 
    files = []
    
    # Extract the complete set of files.
    for buildPath in @paths
      for buildFile in buildPath.files
          files.push buildFile
    
    # Return the sorted set of files.
    files = _(files).sortBy (file) -> file.id
    # files.reverse()
    files
  
  
  ###
  Gets or sets whether the code has been built.
  True after the [build] method has completed.
  ###
  isBuilt: false
  
  
  ###
  Builds the code.
  @param callback(code): Invoked upon completion. 
                         Returns the 'code' property value.
  ###
  build: (callback) -> 
    
    # console.log '@paths', @paths
    
    # Setup initial conditions.
    callback? fnCode(null, null) unless @paths.length > 0
    
    # Build the set of paths.
    buildPaths @paths, =>
      
      files = @files(@paths)
      props = moduleProperties(files)
      
      # Build the uncompressed code.
      code = if @includeRequireJS then Builder.requireJS else ''
      code += """
             require.define({
             #{props}
             });
             """
      
      # Compress the code.
      minified = minifier.compress(code) if @minify is yes
      
      # Prepend the header if there is one.
      if @header?
          code     = "#{@header}\n\n#{code}"
          minified = "#{@header}\n\n#{minified}"
      
      # Store the code function (with a minified version too).
      @code = fnCode(code, minified)
      
      # Finish up.
      @isBuilt = true
      callback? @code
  
  
  ###
  Builds and saves the code to the specified location(s).
  @param options
            - dir:       The path to directory to save the files in.
            - name:      The file name (without an extension).
            - minSuffix: (optional). The minified suffix (default: -min)
  @param callback(code): Invoked upon completion. 
                         Returns the 'code' property value (a function), which contains an
                         extra property of [paths] where the file was saved.
  ###
  save: (options = {}, callback) -> 
    save = => 
      options.code = @code
      Builder.save options, callback
    
    # Build the code (if required).
    if @isBuilt then save()
    else @build -> save()


# PRIVATE --------------------------------------------------------------------------


# Builds the collection of paths.    
buildPaths = (paths, callback) -> 
  count = 0
  build = (path) -> 
      path.build -> 
          count += 1
          callback() if count is paths.length
  build path for path in paths


moduleProperties = (files) -> 
  props = ''
  for file, i in files
      props += file.code.moduleProperty
      unless i is files.length - 1
          props += ',' 
          props += '\n'
  props


# -- STATIC members.
Builder.requireJS = fsUtil.fs.readFileSync("#{core.paths.client}/libs/src/require.js").toString()


###
Saves the code to the specified location(s).
@param options
          - code:      The fnCode object to save.
          - dir:       The path to directory to save the files in.
          - name:      The file name (without an extension).
          - minSuffix: (optional). The minified suffix (default: -min)
@param callback(code): Invoked upon completion. 
                       Returns the 'code' property value (a function), which contains an
                       extra property of [paths] where the file was saved.
###
Builder.save = (options = {}, callback) -> 
  
  # Setup initial conditions.
  code      = options.code
  minSuffix = options.minSuffix ?= '-min'
  dir       = _.rtrim(options.dir, '/')
  name      = options.name
  name      = _(name).strLeftBack('.js') if _(name).endsWith('.js')
  
  files = [
    { path: "#{dir}/#{name}.js",              data: code.standard  }
    { path: "#{dir}/#{name}#{minSuffix}.js",  data: code.minified  }
  ]
  
  # Ensure code exists before saving.
  for file in files
    file.data ?= '// No code saved by builder.'
  
  # Write to disk.
  fsUtil.writeFiles files, (err) -> 
      throw err if err?
      
      # Create a return object with paths attached.
      code = fnCode(code.standard, code.minified)
      code.paths =  
          standard: files[0].path
          minified: files[1].path
      
      # Finish up.
      callback? code



