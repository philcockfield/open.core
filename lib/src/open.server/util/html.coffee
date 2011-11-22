core = require 'open.server'


isDevelopment = -> 
  return core.app.settings.env is 'development'

preventCache = (options = {}) -> 
  value = options.preventCache
  return value if value?
  isDevelopment()


module.exports = 
  ###
  Determines whether the caching should be prevented (true) or allowed (false) 
  by appending a unique query string to the end of a URL.
  @param options : the options object passed the consuming method.
                   the property of interest is 'preventCache'
  ###
  preventCache: preventCache
          
    
  ###
  Creates a <script> tag.
  @param url  : the URL to the javascript file.
  @param options
            - preventCache : Flag indicating if a unique query-string should be 
                      appended to the src url so that it is not cached by
                      the browser (default true if in 'development' mode).
  ###
  script: (url, options = {}) -> 
    url = _.uniqueUrl(url) if preventCache(options)
    "<script src=\"#{url}\" type=\"text/javascript\"></script>"
      
  ###
  Creates a stylesheet <link> tag.
  @param url  : the URL to the javascript file.
  @param options
            - preventCache : Flag indicating if a unique query-string should be 
                      appended to the src url so that it is not cached by
                      the browser (default true if in 'development' mode).
  ###
  css: (url, options = {}) -> 
    url = _.uniqueUrl(url) if preventCache(options)
    "<link rel=\"stylesheet\" href=\"#{url}\">"






