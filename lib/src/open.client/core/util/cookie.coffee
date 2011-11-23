Base = require '../base'


###
A wrapper for the browser cookie providing a consistent property-function API.
###
module.exports = class Cookie extends Base
  ###
  Constructor.
  @param args
          - name:     The name of the cookie (default: 'root').
          - expires:  The number of days until the cookie expires (default: null - never expires).
          - path:     The cookie path (default: '/').
  ###
  constructor: (args = {}) -> 
    # Setup initial conditions.
    super
    @name    = args.name ? 'root'
    @expires = args.expires
    @path    = args.path ? '/'
    
    # Load the 'store' object from the cookie.
    store = parseValue @name
    
    # Prevent needless updates to the cookie when multiple changes
    # to property values occur in short succession.
    lazySave = _.debounce (=> save @, store), 50
    
    # Override the READ / WRITE methods.
    @propertyStore = () =>
        fn = (name, value, options) => 
            if value != undefined
              
              # Write the new value to the cookie.
              store[name] = value
              lazySave()
            
            # Read value from backing model.
            store[name]
    
    # Add defaults as Property functions.
    @addProps @defaults


# PRIVATE --------------------------------------------------------------------------


parseValue = (name) -> 
  
  # Look for the given property name within the complete document cookie string.
  for part in document.cookie.split ';'
    key = _(part).chain().strLeft('=').trim().value()
    if key is name
      # Property found - parse the content.
      part = _(part).strRight '='
      return {} if _.isBlank(part)
      try
        return JSON.parse part
      catch error
        # Malformed JSON.  Return a fresh object.
        console.log 'error', error
        return {}
  
  # Not found, return an empty object.
  {}


save = (cookie, store) ->
  # Build the expiry date string.
  expires = ''
  if cookie.expires?
    date = new Date()
    date.setTime date.getTime() + ( cookie.expires * 24 * 60 * 60 * 1000 )
    expires = "expires=#{date.toGMTString()}; "
  
  # Update the cookie.
  json = JSON.stringify(store)
  document.cookie = "#{cookie.name}=#{json}; #{expires}path=#{cookie.path}"




