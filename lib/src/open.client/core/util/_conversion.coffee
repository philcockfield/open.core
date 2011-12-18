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

  




    