core     = require 'open.client/core'
controls = require 'open.client/controls'

module.exports = class TestHarness extends core.mvc.Module
  constructor: -> 
      
      # Setup initial conditions.
      super module
      @addProps
        selectedDescription: null
      
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
      @descriptions = new @models.Describe.Collection()
      do => 
          for d in HARNESS.suites
            @descriptions.add new @models.Describe d
      HARNESS.suites = [] # Reset the collection.
      
      # Insert the root view.
      @tmpl     = new @views.Tmpl()
      @rootView = new @views.Root()
      options.within?.append @rootView.el
      
      

      
      
    