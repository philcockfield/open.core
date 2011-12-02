module.exports = (module) ->
  index =
    ###
    Posts the given markdown to the server for formatting.
    @param markdown:            The markdown content to post.
    @param callback(err, html): The processed markdown.
    ###
    postMarkdown: (markdown, callback) -> 
      # Prepare the URL.
      url = module.strings.baseUrl ? '/'
      url = _(url).rtrim '/'
      url += '/markdown'
      
      # Prepare the data.
      data =
        source: markdown
        classes:
          code: 'core_simple'
      
      # Submit the request to the server.
      $.ajax
        type:     'POST'
        url:      url
        data:     data
        dataType: 'html'
        success: (data) -> callback? null, data
        error: (err) -> 
          console.log 'Failed to load markdown.'
          console.log ' - Error: ', err
          console.log ' - Message:',  err.responseText
          console.log ' - Url:', url
          callback? err, null

