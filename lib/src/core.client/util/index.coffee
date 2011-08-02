module.exports =
  Property: require './property'

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
