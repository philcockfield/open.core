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
  Attempt to convert the given [view/element/string] to a jQuery object.
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
      
      # Perform conversion.
      return value if (value instanceof jQuery) 
      return value.el if (value.el instanceof jQuery)
      return $(value) if _.isString(value) or (value instanceof HTMLElement)
      
      # Finish up.
      throw 'Cannot convert to jQuery object: ' + value

    