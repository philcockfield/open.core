describe 'Services', ->
  describe 'Pygments', 
    '''
    Source code highlighting service.
    ''', ->
      
      sampleCode = 
        """
        # Comment
        foo = 123
        fn = -> console.log 'foo', foo        
        """
      
      it 'Convert: CoffeeScript', ->
        url = '/pygments'
        data =
          source: sampleCode
          language: 'coffee'
        
        $.ajax
          type: 'POST'
          url: url
          data: data
          dataType: 'html'
          error: (data) -> console.log 'ERROR', data
          success: (data) -> 
            
            el = $ "<div>#{data}</div>"
            page.add el, fill:true
            
    
    
  