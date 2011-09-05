fsUtil    = require '../../fs'
BuildPath = require './build_path'
minifier  = require '../minifier'


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
      - includeRequireJS: Flag indicating if the CommonJS require script should be included (default: false).
  
  ###
  constructor: (paths = [], options = {}) -> 

      # Setup initial conditions.
      paths = [paths] unless _.isArray(paths)
      @includeRequireJS = options.includeRequireJS ?= false
      options.build ?= false
      @code = {}
      
      # Convert paths to wrapper classes.
      @paths = _(paths).map (path) -> new BuildPath(path)
  
  
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
      _(files).sortBy (file) -> file.id
  
  
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
    
    # Setup initial conditions.
    callback?() unless @paths.length > 0
    
    # Builds the set of paths.
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
        
        # Store the code function (with a minified version too).
        @code = fnCode(code, minifier.compress(code))
        
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
      
      # Setup initial conditions.
      minSuffix = options.minSuffix ?= '-min'
      dir       = _.rtrim(options.dir, '/')
      name      = options.name
      name      = _(name).strLeftBack('.js') if _(name).endsWith('.js')
      
      # Save files.
      save = () => 
          code = @code
          files = [
            { path: "#{dir}/#{name}.js",              data: code.standard  }
            { path: "#{dir}/#{name}#{minSuffix}.js",  data: code.minified  }
          ]
          fsUtil.writeFiles files, (err) -> 
              throw err if err?
              
              # Create a return object with paths attached.
              code = fnCode(code.standard, code.minified)
              code.paths =  
                  standard: files[0].path
                  minified: files[1].path
              
              # Finish up.
              callback? code
      
      # Build the code (if required).
      if @isBuilt then save()
      else @build -> save()
        


# -- PRIVATE members.

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


fnCode = (standardCode, minifiedCode) -> 
      fn = (minified) -> 
            if minified then minifiedCode else standardCode
      fn.standard = standardCode
      fn.minified = minifiedCode
      fn



# -- STATIC members.
Builder.requireJS = fsUtil.fs.readFileSync("#{__dirname}/../libs.src/require.js").toString()


