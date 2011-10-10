module.exports = (module) ->
  class Main extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_main'
        @render()
        @_updateState()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @_updateState()
    
    render: -> 
        
        # Insert base HTML structures.
        @html module.tmpl.main()
        
        # Retreive elements.
        @divTitle = @$('p.th_title')
        @divSummary = @$('p.th_summary')
        
        # Finish up.
        @_updateState()
    
    
    _updateState: -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        
        # Update title.
        @divTitle.html suite?.title() ? ''
        @divSummary.html suite?.summary() ? ''
        