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
      @selectedSuite.onChanged (e) => 
              
              # Update state.
              page.reset()
              @selectedSpec null # Reset the spec when the suite changes.
              
              # Invoke the [afterAll] if a current suite is being unloaded.
              if e.oldValue?
                    e.oldValue.afterAll.each (op) -> op.invoke()
              
              # Invoke the [beforeAll] on the new suite that is being.
              suite = e.newValue
              if suite?
                    suite.beforeAll.each (op) -> op.invoke()
              
              # Store the selected item in storage.
              localStorage.selectedRoot  = (suite?.root().title()) ? null
              localStorage.selectedSuite = (suite?.title()) ? null
  
  
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
      
      # Select the initial suite.
      do => 
          return unless localStorage?
          
          # Setup initial conditions.
          selectionTitle = localStorage.selectedSuite
          rootTitle      = localStorage.selectedRoot
          
          # Get the previously selected suite, or the first one in the list.
          rootSuite = @suites.detect (s) -> s.title() is rootTitle
          rootSuite ?= @suites.first()
          
          # Select the suite.
          if rootSuite?
              select = () => 
                      if rootTitle is selectionTitle
                          # Select the root suite.
                          @selectedSuite rootSuite              
                      else
                          # Select the child-suite.
                          rootSuite.init()
                          descendent = rootSuite.descendentByTitle selectionTitle
                          @selectedSuite descendent if descendent?
              
              # Break sync flow to allow view insertion to render 
              # before selection animation starts.
              setTimeout select, 100
      
      
    