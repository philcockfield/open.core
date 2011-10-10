module.exports = (module) ->
  class Main extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_main'
        @render()
        @_updateState()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @_updateState()
        
        # Page events.
        module.page.bind 'add', (e) => @divHost.append e.element
        module.page.bind 'clear', (e) => @clear()
        module.page.bind 'reset', (e) => @reset()
        
    
    render: -> 
        
        # Insert base HTML structures.
        @html module.tmpl.main()
        
        # Retreive elements.
        @divTitle   = @$('p.th_title')
        @divSummary = @$('p.th_summary')
        @divHost    = @$('div.th_host')
        
        # Finish up.
        @_updateState()
    
    clear: -> @divHost.empty()
    
    reset: -> @clear()
    
    _updateState: -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        
        # Update title.
        @divTitle.html suite?.title() ? ''
        @divSummary.html suite?.summary() ? ''
        