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
        module.page.bind 'add',     (e) => @add e.element, e.options
        module.page.bind 'clear',   (e) => @clear()
        module.page.bind 'reset',   (e) => @reset()
        module.page.bind 'css', (e) => @css e.urls
    
    
    add: (el, options = {}) -> 
        # Setup initial conditions.
        width   = formatSizeValue options.width
        height  = formatSizeValue options.height
        
        # Assign style options.
        el.css 'width', width   if width?
        el.css 'height', height if height?
        @trTitle.toggle (options.showTitle ?= true)
        @css options.css
        
        # Insert the element into the host DIV.
        @tdHost.append el
    
    
    clear: -> @tdHost.empty()
    
    
    css: (urls) -> 
        return unless urls?
        urls = [urls] unless _(urls).isArray()
        add = (url) -> 
            return if $("head link[href='#{url}']").length > 0
            $('head').append $("<link type='text/css' rel='stylesheet' href='#{url}'>")
        add url for url in urls
        @
    
    
    reset: -> @clear()
    
    
    render: -> 
        # Insert base HTML structures.
        @html module.tmpl.main()
        
        # Retreive elements.
        @divTitle = @$('div.th_title')
        @trTitle  = @$('tr.th_title')
        @pTitle   = @$('p.th_title')
        @pSummary = @$('p.th_summary')
        @tdHost  = @$('td.th_host')
        
        # Finish up.
        @_updateState()
    
    
    _updateState: -> 
        # Setup initial conditions.
        suite = module.selectedSuite()
        
        # Update title.
        @divTitle.toggle suite?
        if suite?
            # Format title and summary.
            title   = suite.title() ? ''
            title   = _(title).capitalize()
            summary = suite.summary() ? ''
            summary = _(summary).capitalize()
            
            # Update DOM elements.
            @pTitle.html    title
            @pSummary.html  summary



  # PRIVATE --------------------------------------------------------------------------
  formatSizeValue = (value) -> 
        return null unless value?
        return value + 'px' if _(value).isNumber()
        value
      
      
  
  
  # Export
  Main
  




        