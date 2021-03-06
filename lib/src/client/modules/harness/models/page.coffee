###
A simple page model that is accessed from within specs.

Events:
   - add
   - add:css
   - clear
   - reset

###
module.exports = (module) ->
  class Page extends module.mvc.Model
    constructor: -> super
    defaults:
      title:          null  # Gets or sets the title of the page.
      summary:        null  # Gets or sets the summary of the page.
      defaultSummary: null  # Gets or sets the summary used by default when no summary is specified within a suite.
    
    
    # Gets the [ContextPane] - the panel to display options below the control host.
    pane: undefined # Set by Main.
    
    ###
    Returns the summary text.  
    If null the default summary is returned.
    If there is no summary or default summary then an empty-string is returned.
    ###
    getSummary: -> 
      summary = _.nullIfBlank @summary()
      summary = _.nullIfBlank(@defaultSummary()) unless summary?
      summary = '' unless summary?
      summary
    
    
    ###
    Adds a new element to the Test Harness
    @param el : The element to test.
    @param options: 
              - width:     A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80em')
                           If a number greater than 1 is supplied pixels are used (eg. 200 => '200px')
                           If a number between 0..1 is supplied it will be translated to a percentage (eg. 0.35 => '35%')
                           If '*' is supplied it is converted to '100%'.
              - height:    A value for the width of the element being added.  
                           If a string is supplied the value should contain units (eg. '80em')
                           If a number is supplied pixels are used (eg. 200 => '200px')
                           If a number between 0..1 is supplied it will be translated to a percentage (eg. 0.35 => '35%')
                           If '*' is supplied it is converted to '100%'.
              - showTitle: Flag indicating if the title, and description, should be displayed (default true).
              - fill:      Flag indicating if width/height values should be set to '100%' when true (default false).
                           Alternatively specifying a percentage (eg. '70%' or 0.7) will set both sides to the same size.
                           '*' will set both sides to '100%'
              - scroll:    Scroll behavior for container. 'x', 'y', 'xy', null.  Default:null
              - border:    A color (string) or a bolean (yes/no) for whether a border should be put around the hosted control.
              - reset:     Flag indicating if the 'Reset' method should be invoked before adding.
              - className: The class name to add to the containing host element (use this to set special styles for testing).
                           This is added to the [page.el], and is reset for each new suite that is loaded.
    ###
    add: (el, options = {}) -> 
      @reset() if options.reset is yes
      @trigger 'add', element: module.core.util.toJQuery(el), options: options
      el
    
    
    ###
    Adds a stylesheet link to the page.
    @param urls: Array of URL's to the stylehseet(s) to add.
    ###
    css: (urls...) -> @trigger 'css', urls:urls
    
    
    # Clears the currently hosted test element.
    clear: -> @trigger 'clear'
    
    
    # Complete reset of the Test Harness.
    reset: -> @trigger 'reset'
    
    
    ###
    Adds the given markdown content to the host.
    @param content: a string of markdown.
    ###
    markdown: (content) -> 
      @clear()
      module.utils.postMarkdown content, (err, html) => 
        return if err?
        el = $ "<div class=\"th_markdown\">#{html}</div>"
        @add el, fill:true, scroll:'y'
  
  
  