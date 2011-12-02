module.exports = (module) ->
  BaseTab = module.view 'base'
  
  class MarkdownTab extends BaseTab
    constructor: (props = {}) -> 
      # Setup initial conditions.
      super _.extend props, scroll:'y'
      @el.addClass 'th_markdown'
      @addProps
        markdown: null # Gets or sets the source markdown.
      util = module.parent.util
      
      # Syncers.
      syncMarkdown = => 
        @el.html null
        markdown = @markdown()
        if markdown?
          util.postMarkdown markdown, (err, html) => @el.html html unless err?
        
      # Wire up events.
      @markdown.onChanged syncMarkdown
      
      # Finish up.
      syncMarkdown()



