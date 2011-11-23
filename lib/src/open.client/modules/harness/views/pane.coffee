module.exports = (module) ->
  tabs = module.tabs.views
  
  class ContextPane extends module.mvc.View
    defaults:
        height:    250 # Gets or sets the height of the panel (in pixels).
        minHeight: 38  # Gets or sets the minimum height of the panel (in pixels).
    
    constructor: (params = {}) -> 
        super className:'th_context_pane'
        @render()
        @visible false # Not shown by default.
        
        # Append methods onto the 'add' method.
        do => 
          addTab = (options, fnCreate) =>
              # Add the new tab.
              options.content = fnCreate()
              tab = @add options
              
              # Finish up.
              @show() if (options.show ? yes) is yes
              tab
          
          ###
          Adds a new markdown tab to the pane.
          @param options:
                  - markdown      : String of markdown to load.
                  - {tab options} : Standard tab/button options eg. label, selected etc.
                  - show:         : Flag indicating if the pane should be shown (default: true).
          ###
          @add.markdown = do => 
            (options = {}) => addTab options, -> new tabs.Markdown( markdown:options.markdown )
          
          ###
          Adds a tab with data from a url
          @param options:
                  - {tab options} : Standard tab/button options eg. label, selected etc.
                  - show:         : Flag indicating if the pane should be shown (default: true).
                  - url           : The URL of the content to load.
                  - language      : The language of the content (eg. 'css' or 'js').
                  - description   : Optional.  Markdown containing a description of the content.
                  - showLink:     : Optional.  Flag indicating if a link to the raw content should be shown (default: true).
          ###
          @add.remote = do => (options = {}) => 
            tab = addTab options, -> new tabs.Remote( options )
            tab.content.load options
            tab
          
          ###
          Adds a new tab loading css.
          @param options:
                  - {tab options} : Standard tab/button options eg. label, selected etc.
                  - url           : The URL to retrieve the CSS from.
                  - show:         : Flag indicating if the pane should be shown (default: true).
          ###
          @add.css = do => 
            (options = {}) => 
              options.language = 'css'
              @add.remote options
    
    # Gets the number of tabs in the pane.
    count: -> @tabStrip.count()
    
    
    ###
    Shows the pane by setting the [visible] property to true.
    @param options:
              - height: (optional). The number representing the pixel height to set the pane to.
    ###
    show: (options = {}) -> 
        @height options.height if options.height?
        @visible true
    
    
    # Hides the pane by setting the [visible] property to false.
    hide: -> @visible false
    
    
    render: -> 
        @html module.tmpl.contextPane()
        @tabStrip = new module.controls.TabStrip().replace @$('.th_tab_strip')
        @divBody = @$ '.th_body'
    
    
    ###
    Adds a new tab to the pane.
    Note: To remove the tab, call the [remove] method on the returned tab.
    
    @param options: The options for the tab (eg. label:'My Label')
              - content: (optional) A view/element to insert as content.
              
    @returns the new [Tab] button.
    ###
    add: (options = {}) -> 
        
        # Setup initial conditions.
        options.label ?= 'Untitled'
        
        # Insert the tab.
        tab = @tabStrip.add options
        tab.selected true if @count() is 1 # Ensure at least one tab is selected.
        
        # Insert tab content element.
        tab.elContent.addClass 'th_tab_content'
        if options.content?
              tab.elContent.append module.util.toJQuery(options.content)
              tab.content = options.content
        @divBody.append tab.elContent
        
        # Wire up events.
        tab.bind 'removed', (e) => e.tab.elContent.remove() # Remove the corresponding content element.
        
        # Finish up.
        tab
    
    
    # Removes all tabs from the pane.
    clear: -> @tabStrip.clear()
    
    
    # Clears and hides the pane.
    reset: -> 
        @hide()
        @clear()
    
