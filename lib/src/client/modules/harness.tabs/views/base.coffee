module.exports = (module) ->
  class BaseTab extends module.mvc.View
    defaults:
      scroll: null # Gets or sets the scroll behavior of the content (values: null, 'x', 'y' or 'xy').
    
    constructor: (props = {}) -> 
      # Setup initial conditions.
      super _.extend props, className:'th_tab'
      
      # Enabled scrolling.
      new module.controls.controllers.Scroll @
      
    
    
    ###
    Adds the tab to the TestHarness pane.
    @param options
            label:    The display label for the tab in the TabStrip.
            selected: Flag indicating if the tab should be selected (default: false)
            show:     Flag indicating if the context-pane containing the tab(s) should be shown (default: true).
    ###
    addToPane: (options = {}) -> 
      # Setup initial conditions.
      pane = page.pane
      options.show ?= yes
      
      # Insert the tab.
      pane.add
        label: options.label
        content: @
      
      # Finish up.
      pane.show() if options.show is yes
      @





        