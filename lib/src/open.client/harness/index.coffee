core     = require 'open.client/core'
controls = require 'open.client/controls'

module.exports = class TestHarness extends core.mvc.Module
  constructor: -> 
      
      # Setup initial conditions.
      super module
      @addProps
        selectedSuite: null
      
      # Store common references.
      @core     = core
      @mvc      = core.mvc
      @controls = controls
  
  
  ###
  Initializes the TestHarness.
  This should only be called after the page has finishe loading (ready).
  @param options:
          - within:   (optional) Element to insert the harness within.  Default: 'body'.
  ###
  init: (options = {}) -> 
      
      # Setup initial conditions.
      options.within ?= 'body'
      super options
      
      # Create root collection describe blocks.
      @suites = new @models.Suite.Collection()
      do => 
          for d in HARNESS.suites
            @suites.add new @models.Suite d
      HARNESS.suites = [] # Reset the collection.
      
      # Insert the root view.
      @tmpl     = new @views.Tmpl()
      @rootView = new @views.Root()
      options.within?.append @rootView.el
      
      

      
      
    