module.exports = (module) ->
  MarkdownTab = module.view 'markdown'
  
  class RemoteContentTab extends MarkdownTab
    constructor: (props = {}) -> 
      super _.extend props
    
    
    ###
    Loads the content from the given URL.
    @param options
            - url         : The URL of the content to load.
            - language    : The language of the content (eg. 'css' or 'js').
            - description : Optional.  Markdown containing a description of the content.
            - showLink:   : Optional.  Flag indicating if a link to the raw content should be shown (default: true).
    ###
    load: (options = {}, callback) -> 
      
      # Setup initial conditions.
      @markdown null
      url      = options.url
      language = options.language
      unless url?
        # Nothing to load.
        callback?()
        return
      
      # Load the content.
      $.get url, (data) =>
        
        # Prepare the data.
        data = ":#{options.language}\n#{data}" if language?
        data = prependEachLine data
        
        # Prepare the link.
        link = ''
        if (options.showLink ? yes) is yes
          link = "[#{url}](#{window.location.origin}#{url})\n"
          
        # Prepare the description.
        desc = options.description ? ''
        if desc?
          desc += '\n\n'
        
        markdown = """
                   #{desc}#{link}
                   #{data}
                   """
        
        # Finish up.
        @markdown markdown
        callback?()


# PRIVATE --------------------------------------------------------------------------


prependEachLine = (data, prepend = '    ') -> 
  result = ''
  for line in data.split '\n'
    result += "#{prepend}#{line}\n"
  result
  
  



