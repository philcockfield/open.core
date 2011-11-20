module.exports = 
  ###
  Converts a value to boolean.
  @param value: To convert.
  @returns True for:
            - true
            - 1
            - 'true' (any case permutation)
            - 'yes'
            - 'on'
           False for:
            - false
            - 0
            - 'false' (any case permutation)
            - 'no'
            - 'off'
           Null for:
            - object
  ###
  toBool: (value) ->
      return value if _.isBoolean(value)
      return false unless value?
      
      if _.isString(value)
          value = _.trim(value).toLowerCase()
          
          return true if value == 'true' or value == 'on' or value == 'yes'
          return false if value == 'false' or value == 'off' or value == 'no'
          return null
      
      if _.isNumber(value)
          return true if value == 1
          return false if value == 0
          return null
      
      # No match.
      null
      
  
  ###
  Attempts to convert the given [view/element/string] to a jQuery object.
  @param value : The value to convert.  This can be either a:
                  - jQuery object (returns same value)
                  - string (CSS selector)
                  - an MVC View (returns .el)
                  - HTMLElement (wraps in jQuery object)
  @returns a jQuery object, or null if the value was undefined/null.
  ###
  toJQuery: (value) ->       
      
      # Setup initial conditions.
      return value if not value?
      
      # Check whether the object is already a jQuery object, or is an MVC [View].
      return value if (value instanceof jQuery) 
      return value.el if (value.el instanceof jQuery) 
      
      # Not a known type - wrap it as a jQuery object.
      return $(value)
      
  
  ###
  Converts < and > ' and " and & characters to corresponding ascii codes.
  @param html: The HTML string to convert.
  @returns the converted string.
  ###
  escapeHtml: (html) -> 
      return null unless html?
      html = html
              .replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#39;")
  
  ###
  Converts an escaped string back into HTML.
  @param esacped: The escaped string to convert.
  @returns the converted string.
  ###
  unescapeHtml: (escaped) -> 
      return null unless escaped?
      escaped = escaped
              .replace(/&amp;/g, "&")
              .replace(/&lt;/g, "<")
              .replace(/&gt;/g, ">")
              .replace(/&quot;/g, "\"")
              .replace(/&#39;/g, "'")

  




    