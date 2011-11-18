describe 'Services', ->
  post = (url, data, callback) -> 
      console.log 'Posting to: ', url
      console.log 'Data:', data
      console.log '...'
      $.ajax
        type: 'POST'
        url: url
        data: data
        dataType: 'html'
        error: (err) -> 
            console.log '- Error: ', err
            callback? err, null
            
        success: (data) -> 
            el = $ "<div style='font-size:10pt;'>#{data}</div>"
            console.log ' - Success: ', el
            page.add el, fill:true, reset:true
            callback? null, 
              el:   el
              data: data
  
  describe 'Pygments', 'Source code highlighting service.', -> 
    url = '/pygments'
    it 'Convert: CoffeeScript', ->
      post url, 
        language: 'coffee'
        source: 
          '''
          # Comment
          foo = 123
          fn = -> console.log 'foo', foo
          '''
  
  
  # describe 'Markdown', 'Markdown to HTML conversion service.', ->
  #   it 'Convert: simple markdown', ->
      
      
      
    
    
  
  
  
  
  
  
  
  
  
  
  
  
  