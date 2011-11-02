###
Underscore extensions.
###
_.mixin

  # Overrides [underscore.string]'s verion of this method to only capitalize
  # the first letter, not lower-case the remainder of the string.
  capitalize: (text) -> 
      
      # Setup initial conditions.
      return text unless text?
      return text unless _.isString(text)
      return text if _.isBlank(text)
      
      # Convert string.
      text[0].toUpperCase() + text.substring(1)
      
    