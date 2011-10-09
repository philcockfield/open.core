core = require 'open.client/core'


module.exports = class TestHarness extends core.mvc.Module
  constructor: -> 
      super module
  
  
  ###
  Initializes the TestHarness
  @param options:
          - within:   (optional) Element to insert the harness within.  Default: 'body'.
  ###
  init: (options = {}) -> 
      
      # Setup initial conditions.
      options.within ?= 'body'
      super options
      
      # Insert the root view.
      @rootView = new @views.Root()
      options.within?.append @rootView.el
    
  
  