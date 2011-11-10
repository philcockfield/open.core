core = require 'open.client/core'

###
UI for authentication and authorization.
###
module.exports = class Auth extends core.mvc.Module
  defaults:
    mode: null # Gets or sets the mode. Values: null | 'sign_in'
  
  
  constructor: () -> super module
  
  
  ###
  Initializes the module.
  @param options
            within: The element to initialize the module within.
  ###
  init: (options = {}) -> 
      
      # Setup initial conditions.
      super options
      
      # Create the root view.
      @rootView = new @views.Root()
      options.within.append @rootView.el if options.within?
      
      # Finish up.
      @
      
  

