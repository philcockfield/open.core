core = require 'open.client/core'

###
UI for authentication and authorization.
###
module.exports = class Auth extends core.mvc.Module
  constructor: () -> 
      super module
  
  
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
      
      # Finish up.
      @


