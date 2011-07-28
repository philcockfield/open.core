

isDevelopment = -> 
  core = require 'open.core'
  return core.app.settings.env is 'development'


module.exports = 
  
  ###
  Creates a <script> tag.
  @param src    : the URL to the javascript file.
  @param options
            - unique : Flag indicating if a unique query-string should be 
                      appended to the src url so that it is not cached by
                      the browser (default true if in 'development' mode)
  ###
  script: (src, options = {}) -> 
      
      
      unique = options.unique ?= true
      src = _.uniqueUrl(src) if unique and isDevelopment()
      "<script src=\"#{src}\" type=\"text/javascript\"></script>"