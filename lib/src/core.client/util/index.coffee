module.exports =
  ###
  Converts a value to boolean.
  ###
  toBool: (value) ->
      return false unless value?
      return null unless _.isString(value)
      value == 'true'
