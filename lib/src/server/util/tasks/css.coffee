core   = require '../../../server'
fs     = require 'fs'


###
Tasks related to CSS.
###
module.exports = 
  
  ###
  Walks a directory converting each file into data-URI's
  storing them as constants for use within Stylus.
  
  These can be used directly within CSS using the [background-image] style.
  
  See: http://en.wikipedia.org/wiki/Data_URI_scheme
  
  @param sourceDir:  The source directory to look within.
  @param targetFile: The target stylus file to save the constants to.
  @param options:
            - extensions: The file extensions to include (default: png jpg jpeg).
            - type:       The type of data that resides within the file (default: image).
  ###
  toDataUris: (sourceDir, targetFile, options = {}) -> 
      
      # Setup initial conditions.
      log       = core.log
      fsUtil    = core.util.fs
      
      # Set default values.
      extensions = options.extensions ? 'png jpg jpeg'
      extensions = '' unless extensions?
      extensions = extensions.split ' '
      type       = options.type ? 'image'
      
      # Filter on specified file types.
      include = (path) -> 
          return true if extensions.length is 0
          for extention in extensions
            return true if _(path).endsWith ".#{extention}"
          false
      
      # Get the paths to the files.
      paths = fsUtil.readDirSync sourceDir, deep:true, dirs:false
      paths = _(paths).filter (p) -> include(p)
      
      toDataUri = (path) -> 
          extension = _(path).strRightBack('.').toLowerCase()
          data = fs.readFileSync path
          "data:#{type}/#{extension};base64,#{data.toString('base64')}"
      
      getId = (path) -> 
          # Remove file extension and replace folder dividers with double-underscores.
          id = _(path).chain().strLeftBack('.').ltrim('/').value()
          id = id.replace /\//g, '__' 
          id = id.toUpperCase()
      
      # Prepare content to save.
      data = """
             /*
                Data URI constants.
                - Type: #{type}
                - Extensions: #{extensions}
                
                See: See: http://en.wikipedia.org/wiki/Data_URI_scheme
                
                Example usage: Reference these constants within the 
                               background-image style.
                
                WARNING: This content is auto-generated.  Edits to this
                file will be lost the next time the file is generated.
             */
             
             
             """
      
      files = []
      for path in paths
        
        # Prepare data.
        uri  = toDataUri path
        path = path = _(path).strRight sourceDir
        id   = getId path
        log " - id:", color.blue, id
        
        # Store in the return array.
        files.push
          id:   id
          path: path
          uri:  uri
        
        # Append data file.
        data += """
                
                /* #{_(type).capitalize()}: #{path} */
                #{id} = url("#{uri}")
                
                """
      
      # Save file.
      fs.writeFileSync targetFile, data
      log 'Done', color.green
      log " - See: #{targetFile}", color.green
      log()
      
      # Finish up.
      files



