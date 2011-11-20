describe 'Services', ->
  post = (url, data, callback) -> 
      page.clear()
      console.log ''
      console.log 'Posting to: ', url
      console.log 'Data:', data
      console.log '...'
      $.ajax
        type: 'POST'
        url: url
        data: data
        dataType: 'html'
        error: (err) -> 
            console.log ' - Error: ', err
            console.log ' - Message:',  err.responseText
            callback? err, null
            
        success: (data) -> 
            el = $ "<div style='font-size:10pt;'>#{data}</div>"
            console.log ' - Success: ', el
            page.add el, fill:true, reset:true, scroll:'y'
            callback? null, 
              el:   el
              data: data
  
  describe 'Pygments', 'Source code highlighting service.', -> 
    url = '/pygments'
    beforeAll ->
      post url, 
        language: 'coffee'
        source: 
          '''
          # Comment.
          foo = 123
          fn = (prefix) -> console.log "#{prefix}: ", foo
          for i in [1..5]
            foo += 1
            fn('Item')
          '''
  
  
  describe 'Markdown', 'Markdown to HTML conversion service.', ->
    url = "/markdown"
    beforeAll -> toMarkdown simple
    it 'Markdown Specimen', -> toMarkdown simple
    it 'Code Blocks', -> toMarkdown codeBlocks
    
    toMarkdown = (source) -> post url, source:source
    
    simple = 
      '''
      # H1 Title
      Some markdown.
      An [internal link](/harness/#services/pygments)
      and an
      [external link](https://github.com/evilstreak/markdown-js).  
      **Bold**, *italic* converted to em--dash
      
      >> Quote
      
      ## H2 Title
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor. Cras convallis purus sed massa placerat sed cursus sapien consectetur. In hac habitasse platea dictumst. Nullam ac neque eu libero dictum iaculis in convallis erat. Sed et tortor quis justo congue condimentum sed egestas orci. Aenean a ipsum mattis mi bibendum varius viverra at erat. Nunc arcu neque, sodales eget placerat vel, vehicula ut orci. Mauris euismod consectetur mauris quis imperdiet. Cras pharetra egestas felis sit amet egestas.  
      
      ### H3 Title
      #### H4 Title
      ##### H5 Title
      
      - Item 1
      - Item 2
        - **Item A** (bold)  
          Next line on item-a after two spaces - makes two <br>'s
        - Item B
          
          New <p> - Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          
        - **Item C**: Lorem [ipsum](http://google.com) dolar.
      
      ---
      
      Inline `code snippet`
        
          # Comment.
          foo = 123
          fn = -> console.log 'foo', foo
        
      '''
    
    codeBlocks =
      '''
      Code block:
      
          # Comment.
          foo = 123
          fn = -> console.log 'foo', foo
      
      
      Code snippet: `cake specs`
      
      '''
    
  
  
  
  
  
  
  
  
  
  
  
  
  