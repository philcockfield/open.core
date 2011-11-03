core     = require 'open.client/core'
controls = require 'open.client/controls'

module.exports = class Auth extends core.mvc.Module
  constructor: () -> 
      super module
      @core     = core
      @mvc      = core.mvc
      @controls = controls
  
  
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
      
      

