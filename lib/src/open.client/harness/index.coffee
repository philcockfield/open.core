core     = require 'open.client/core'
controls = require 'open.client/controls'

module.exports = class TestHarness extends core.mvc.Module
  constructor: -> 
      
      # Setup initial conditions.
      super module
      @addProps
          selectedSuite: null
          selectedSpec:  null
      
      # Store common references.
      @core     = core
      @mvc      = core.mvc
      @controls = controls
      
      # Wire up events.
      @selectedSuite.onChanged => 
          page.reset()
          @selectedSpec null # Reset the spec when the suite changes.
  
  
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
      
      # Store page reference on Module and make it available to spec
      # by storing it in the global object.
      Page = @model 'page'
      window.page = @page = new Page()
      
      # Create root collection describe blocks.
      Suite = @models.Suite
      @suites = new @models.Suite.Collection()
      Suite.getSuites @suites
      
      # Insert the root view.
      @tmpl     = new @views.Tmpl()
      @rootView = new @views.Root()
      options.within?.append @rootView.el
      
      # Select the first suite.
      @selectedSuite @suites.first()
      
    