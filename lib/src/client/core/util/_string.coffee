

fnBlank = _.isBlank


###
Underscore string extensions.
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
      
  
  # Overrides [underscore.string]'s verion of this method to 
  # handle null/undefined values.
  isBlank: (text) -> 
    return true unless text?
    fnBlank text
  
  
  ###
  Converts a blank string to null.
  ###
  nullIfBlank: (text) -> if _.isBlank(text) then null else text




  