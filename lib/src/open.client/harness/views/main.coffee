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
        module.page.bind 'add',   (e) => @add e
        module.page.bind 'clear', (e) => @clear()
        module.page.bind 'reset', (e) => @reset()
    
    
    add: (options = {}) -> @divHost.append options.element
    
    clear: -> @divHost.empty()
    
    reset: -> @clear()

    render: -> 
        
        # Insert base HTML structures.
        @html module.tmpl.main()
        
        # Retreive elements.
        @divTitle = @$('div.th_title')
        @pTitle   = @$('p.th_title')
        @pSummary = @$('p.th_summary')
        @divHost  = @$('div.th_host')
        
        # Store the host DIV on the [page] object.
        page.div = @divHost
        
        # Finish up.
        @_updateState()
    
    _updateState: -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        
        # Update title.
        @divTitle.toggle suite?
        if suite?
            @pTitle.html suite.title() ? ''
            @pSummary.html suite.summary() ? ''
        