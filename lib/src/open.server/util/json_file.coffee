fs = require 'fs'


###
Base class for wrappers around a [.json] file.
###
module.exports = class JsonFile
  ###
  Constructor.
  @param path:        The path to the [.json] file, or directory (if the fileName parameter is specified).
  @param fileName:    Optional.  The name of the file to use if only a directory path may be specified.
  ###
  constructor: (path, fileName = null) -> 
    
    # Setup initial conditions.
    throw new Error 'No path specified' unless path?
    
    # Format and store the path.
    path = JsonFile.formatPath path, fileName
    @path = path.path
    @dir = path.dir
    
    # Load the data from file.
    try
      @data = fs.readFileSync @path, 'utf8'
    catch error
      throw new Error "Failed to load JSON from the file: #{@path}\nERROR: #{error.message}"
    
    # Parse the JSON.
    try
      @data = JSON.parse @data.toString()
    catch error
      throw new Error "Failed to parse JSON from the file: #{@path}\nERROR: #{error.message}"
    


# STATIC --------------------------------------------------------------------------


###
Formats a path to a JSON file.
@param path:        The path to the [.json] file, or directory (if the fileName parameter is specified).
@param fileName:    Optional.  The name of the file to use if only a directory path may be specified.
@returns object:
          - path: The formatted file path.
          - dir:  The directory path.
###
JsonFile.formatPath = (path, fileName = null) -> 
  
  # Setup initial conditions.
  throw new Error 'No path specified' unless path?
  path      = _(path).trim()
  
  # Format for explicit file-name.
  if fileName? and _(path).endsWith('.json') isnt true
    fileName  = _(fileName).trim()
    fileName  = _(fileName).ltrim('/')
    
    if _(path).isBlank()
      path = fileName
    else
      path      = _(path).strLeft fileName
      path      = _(path).rtrim '/'
      path      = "#{path}/#{fileName}"
  
  # Format the directory.
  dir   = null
  if _(path).include '/'
    dir   = _(path).strLeftBack '/'
    dir   = _(dir).rtrim '/'
    dir   = null if _(dir).isBlank()
  
  # Finish up.
  return result =
    path: path
    dir:  dir




