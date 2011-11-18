describe 'Services', ->
  post = (url, data, callback) -> 
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
    it 'Convert: CoffeeScript', ->
      post url, 
        language: 'coffee'
        source: 
          '''
          # Comment
          foo = 123
          fn = -> console.log 'foo', foo
          '''
  
  
  describe 'Markdown', 'Markdown to HTML conversion service.', ->
    url = "/markdown"
    beforeAll -> simple()
    
    simple = -> 
      post url,
        source:
          '''
          # H1 Title
          Some markdown [link](https://github.com/evilstreak/markdown-js).  
          **Bold**, *italic*
          
          >> Quote
          
          ## H2 Title
          ### H3 Title
          ### H4 Title
          
          - Item 1
          - Item 2
            - Item a
            - Item b
            - Item c
          
          ---
          
          Inline `code snippet`
              
              var foo = 123
              
          '''
    
    it 'Convert: Simple Markdown', -> simple()
      
          
      
      
      
    
    
  
  
  
  
  
  
  
  
  
  
  
  
  