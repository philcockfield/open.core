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
        
        console.log 'Posting to: ', url
        $.ajax
          type: 'POST'
          url: url
          data: data
          dataType: 'html'
          error: (data) -> console.log 'ERROR', data
          success: (data) -> 
            el = $ "<div style='font-size:10pt;'>#{data}</div>"
            page.add el, fill:true
    
    
  