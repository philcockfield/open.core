core = require 'open.client/core'

class AuthCookie extends core.util.Cookie
  defaults:
    provider: null
  constructor: () -> super name:'core-auth'
cookie = new AuthCookie() # Singleton instance.


###
UI for authentication and authorization.

Events:
 - click:signIn - Fires when the sign in button is selected (bubbled from the [Root/SignIn] control).

###
module.exports = class Auth extends core.mvc.Module
  constructor: (props) -> 
    super module, props
    @cookie = cookie    
  
  defaults:
    mode: 'sign_in' # Gets or sets the mode. Values: null | 'sign_in'
  
  
  
  ###
  Initializes the module.
  @param options
            within: The element to initialize the module within.
            mode:   Sets the module's mode.
  ###
  init: (options = {}) -> 
      
      # Setup initial conditions.
      super options
      @mode options.mode if options.mode?
      
      # Create the root view.
      @rootView = new @views.Root()
      @bubble 'click:signIn', @rootView
      options.within.append @rootView.el if options.within?
      
      # Finish up.
      @
      
  

