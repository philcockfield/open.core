using = (module) -> require 'open.client/core/util/' + module

module.exports =
  Property:   using 'property'

  ###
  Executes a [require] call within a try/catch block.
  @param path : Path to the require statement.
  @param options
            - throw: Flag indicating if the errors should be thrown (default: false)
            - log:   Flag indicating if errors should be written to the console (default: false)
  ###
  tryRequire: (path, options = {}) -> 
    throwOnError = options.throw ?= false
    log = options.log ?= false
    try
        window.require path
    catch error
        throw error if throwOnError
        console?.log '[tryRequire] Failed to load module: ' + path if log
    

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
