module.exports = (module) ->
  util = module.core.util
  
  class Main extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_main'
        @render()
        @_updateState()
        page = module.page
        
        # Syncers.
        syncSummary = => @_syncSummary()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @_updateState()
        
        # - Page events.
        page.bind 'add',       (e) => @add e.element, e.options
        page.bind 'clear',     (e) => @clear()
        page.bind 'reset',     (e) => @reset()
        page.bind 'css',       (e) => @css e.urls
        page.title.onChanged   (e) => @pTitle.html   e.newValue
        page.summary.onChanged syncSummary
        page.defaultSummary.onChanged syncSummary
    
    
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
        
        # Update CSS options.
        @css options.css
        util.syncScroll el, options.scroll if options.scroll?
        
        # Update the host pane elements.
        @trTitle.toggle (options.showTitle ?= true)
        
        # Insert the element into the host DIV.
        @tdHost.addClass options.className if options.className?
        @tdHost.append el
    
    
    # Removes the test element from the DOM.
    clear: -> 
      @tdHost.empty()
      @tdHost.attr 'class', 'th_host'
    
    
    ###
    Adds a stylesheet <link> to the page.
    @param urls: One or more urls to stylehseets to add to the page.
    ###
    css: (urls) -> 
        return unless urls?
        urls = [urls] unless _(urls).isArray()
        add = (url) -> 
            return if $("head link[href='#{url}']").length > 0
            $('head').append $("<link type='text/css' rel='stylesheet' href='#{url}'>")
        add url for url in urls
        @
    
    
    # Resets the control to it's original condition.
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
              Pane = module.view('pane')
              pane        = new Pane().replace @$('div.th_context_pane')
              page.pane   = pane
              
              # Keep heights in sync.
              syncHeight = => syncPaneHeight @
              pane.visible.onChanged syncHeight
              pane.height.onChanged  syncHeight
              
              # Finish up.
              pane
              
        @pane = createContextPane()
        
        # Finish up.
        @_updateState()
    
    
    _updateState: -> 
        # Setup initial conditions.
        suite = module.selectedSuite()
        syncPaneHeight @
        
        # Update title and summary.
        @divTitle.toggle suite?
        @_syncSummary()
    
    
    _syncSummary: -> 
        @pSummary.html module.page.getSummary()
        
        util.formatLinks @pSummary
        
      
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  formatBorderValue = (value) -> 
      return null unless value?
      value = '#666666' if _(value).isBoolean()
      value
  
  
  formatSizeValue = (value, fill) -> 
      isNumberPercent = (num) -> (0 <= num <= 1)
      
      unless value?
          return '100%' if fill is true
          return fill if _(fill).isString()
          return fill * 100 + '%' if isNumberPercent(fill)
          return null
      
      if _(value).isNumber()
        if isNumberPercent(value)
          value = value * 100 + '%' 
        else
          value += 'px' 
      else if _(value).isString()
        value = _(value).trim()
        value = '100%' if value is '*'
      
      value
  
  
  syncPaneHeight = (view) -> 
      # Setup initial conditions.
      pane = view.pane
      min  = pane.minHeight()
      
      # Calculate height.
      if pane.visible()
          height = pane.height()
          height = min if height < min
      else
          height = 0
      
      # Sync elements
      height += 'px'
      view.divRoot.css 'bottom', height
      pane.el.css 'height', height
  
  
  # Export.
  Main
  
