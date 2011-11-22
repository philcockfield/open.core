core  = require 'open.client/core'
Tabs  = require 'open.client/harness.tabs'

###
The visual TestHarness module.
###
module.exports = class TestHarness extends core.mvc.Module
  constructor: -> 
    # Setup initial conditions.
    super module
    @addProps
      selectedSuite: null
      selectedSpec:  null
    
    # Store common references.
    @util = core.util
    @tabs = new Tabs().init()
    
    # Wire up events.
    @selectedSuite.onChanged (e) => 
      # Setup initial conditions.
      oldSuite = e.oldValue
      newSuite = e.newValue
      
      # Update state.
      @page.reset()
      @selectedSpec null # Reset the spec when the suite changes.
      
      # Invoke the [afterAll] if a current suite is being unloaded.
      # This starts at the the closest suite and works out to the most distant ancestor suite.
      if oldSuite?
        _(oldSuite.ancestors(direction:'ascending')).each (suite) -> 
          suite.afterAll.each (op) -> op.invoke()
      
      # Invoke the [beforeAll] on the new suite that is being.
      # This starts at the root most ancestor suite and works down to the this (the closest) suite.
      if newSuite?
        _(newSuite.ancestors(direction:'descending')).each (suite) -> 
          suite.beforeAll.each (op) -> op.invoke()
  
  
  ###
  Initializes the TestHarness.
  This should only be called after the page has finishe loading (ready).
  @param options:
          - within:   (optional) Element to insert the harness within.  Default: 'body'.
          - strings:
              suites:  Display title of the 'Suites' list.
              specs:   Display title of the 'Specs' list.
  ###
  init: (options = {}) -> 
    # Setup initial conditions.
    options.within ?= 'body'
    super options
    @options = options
    window.HARNESS ?= {} # Used for testing.  This would otherwise be set in the page.
    
    # Exit out if in debug mode.
    # This mode is just so sub-views can be pulled up within the TestHarness itself.
    return @ if options.debug is yes
    
    # Store page reference on Module and make it available to spec
    # by storing it in the global object.
    Page = @model 'page'
    window.page = @page = new Page()
    
    # Set default strings.
    strings = options.strings ?= {}
    strings.suites = 'Suites'
    strings.specs  = 'Specs'
    
    # Configure for iOS.
    document.ontouchmove = (e) -> e.preventDefault() # Suppress page scroll bouncing.
    
    # Create root collection describe blocks.
    Suite   = @models.Suite
    @suites = new @models.Suite.Collection()
    Suite.getSuites @suites
    
    # Insert the root view.
    @tmpl     = new @views.Tmpl strings:strings
    @rootView = new @views.Root()
    options.within?.append @rootView.el
    
    # Create controllers
    new (@controller 'url_selection')()
    
    # Finish up.
    @
  
  
  ###
  Logs an error message.
  @param error: The [error] exception object to write.
  ###
  logError: (error) -> 
    return unless console?
  
    logProperty = (propName) -> 
        text = error[propName]
        if text?
          console.log " - #{propName}:"
          console.log "       #{text}"
  
    console.log ' - Error: ', error
    logProperty 'message'
    logProperty 'stack'
  
  
    