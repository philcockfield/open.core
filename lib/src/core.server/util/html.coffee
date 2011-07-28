

isDevelopment = -> 
  core = require 'open.core'
  return core.app.settings.env is 'development'


module.exports = 
  ###
  Determines whether the caching should be prevented (true) or allowed (false) 
  by appending a unique query string to the end of a URL.
  @param options : the options object passed the consuming method.
                   the property of interest is 'preventCache'
  ###
  preventCache: (options = {}) -> 
          value = options.preventCache
          return value if value?
          isDevelopment()
            

    
    
  ###
  Creates a <script> tag.
  @param src    : the URL to the javascript file.
  @param options
            - preventCache : Flag indicating if a unique query-string should be 
                      appended to the src url so that it is not cached by
                      the browser (default true if in 'development' mode).
  ###
  script: (src, options = {}) -> 
      src = _.uniqueUrl(src) if @preventCache(options)
      "<script src=\"#{src}\" type=\"text/javascript\"></script>"