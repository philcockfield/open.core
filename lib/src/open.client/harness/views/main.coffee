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
        module.page.bind 'css',     (e) => @css e.urls
    
    
    # See [page] object for documentation on available options.
    add: (el, options = {}) -> 
        # Setup initial conditions.
        return unless el?
        
        # Format style options.
        width   = formatSizeValue options.width, options.fill
        height  = formatSizeValue options.height, options.fill
        border  = formatBorderValue options.border
        
        # Assign style options.
        el.css 'width',  width   if width?
        el.css 'height', height  if height?
        el.css 'border', "solid 1px #{border}" if border?
          
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
        # Setup initial conditions.
        page = module.page
        
        # Insert base HTML structures.
        @html module.tmpl.main()
        
        # Retreive elements.
        @divTitle = @$ 'div.th_title'
        @trTitle  = @$ 'tr.th_title'
        @pTitle   = @$ 'p.th_title'
        @pSummary = @$ 'p.th_summary'
        @divRoot  = @$ 'div.th_host'
        @tdHost   = @$ 'td.th_host'
        
        # Store the host element so that it can be passed to 'init' methods of modules.
        page.el = @tdHost
        
        # Initialize the context pane.
        createContextPane = => 
              # Insert the control.
              ContextPane = module.view('context_pane')
              pane = new ContextPane().replace @$('div.th_context_pane')
            
              # Keep heights in sync.
              syncHeight = () => 
                    @divRoot.css 'bottom', (if pane.visible() then '250px' else '0px')
              pane.visible.onChanged syncHeight
              syncHeight()
            
              # Finish up.
              pane
        
        page.pane = createContextPane()
        
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
  
  
  formatBorderValue = (value) -> 
      return null unless value?
      value = '#666666' if _(value).isBoolean()
      value
  
  formatSizeValue = (value, fill) -> 
        unless value?
            return '100%' if fill is true
            return null
        
        return value + 'px' if _(value).isNumber()
        value
  
  
  # Export.
  Main
  
