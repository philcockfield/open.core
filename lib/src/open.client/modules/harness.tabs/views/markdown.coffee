module.exports = (module) ->
  BaseTab = module.view 'base'
  
  class MarkdownTab extends BaseTab
    constructor: (props = {}) -> 
      # Setup initial conditions.
      super _.extend props, scroll:'y'
      @el.addClass 'th_markdown'
      @addProps
        markdown: null # Gets or sets the source markdown.
      
      # Syncers.
      syncMarkdown = => 
        @el.html null
        markdown = @markdown()
        if markdown?
          post markdown, (err, html) => @el.html html unless err?
        
      # Wire up events.
      @markdown.onChanged syncMarkdown
      
      # Finish up.
      syncMarkdown()


# PRIVATE --------------------------------------------------------------------------


post = (markdown, callback) -> 
    data =
      source: markdown
      classes:
        code: 'core_simple'
    
    $.ajax
      type:     'POST'
      url:      '/markdown'
      data:     data
      dataType: 'html'
      success: (data) -> callback? null, data
      error: (err) -> 
          console.log 'Failed to load markdown.'
          console.log ' - Error: ', err
          console.log ' - Message:',  err.responseText
          callback? err, null


    