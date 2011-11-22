describe 'Services', ->
  post = (url, data, callback) -> 
      page.clear()
      console.log ''
      console.log 'Posting to: ', url
      console.log 'Data:', data
      promise = $.ajax
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
      console.log '...', promise
  
  describe 'Pygments', 'Source code highlighting service.', -> 
    url        = '/pygments'
    sampleCode = 
          '''
          # Comment.
          foo = 123
          fn = (prefix) -> console.log "#{prefix}: ", foo
          for i in [1..5]
            foo += 1
            fn('Item')
          '''
    highlight = (source) -> 
      post url, 
        language:   'coffee'
        source:     source
    
    beforeAll -> highlight sampleCode
    it 'Highlight Code', -> highlight sampleCode
  
  
  describe 'Markdown', 'Markdown to HTML conversion service.', ->
    url       = '/markdown'
    codeClass = 'core_simple'
    beforeAll -> toMarkdown codeBlocks
    it 'Markdown Specimen', -> toMarkdown simple
    it 'Code Blocks', -> toMarkdown codeBlocks
    it 'Code Block Style: inset',  -> codeClass = 'core_inset'
    it 'Code Block Style: simple', -> codeClass = 'core_simple'
    
    toMarkdown = (source) -> 
      classes =
        code: codeClass
      post url, source:source, classes:classes
    
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
          
          :coffee
          # Comment.
          foo = 123
          fn = -> console.log 'foo', foo
        
      '''
    
    codeBlocks =
      '''
      Code snippet: `cake specs`
      
      Code block - no highlighting:
      
          # Comment.
          foo = 123
          fn = -> console.log 'foo', foo
      
      CoffeeScript - `:coffee`
      
          :coffee
          # Comment. <foo> & 'thing' in "quotes".
          foo = 123
          fn = (prefix) -> console.log "#{prefix}: ", foo
          for i in [1..5]
            foo += 1
            fn('Item')
      
      HTML - `:html`
      
          :html
            <html>
              <head>
                <title>My Page</title>
                <style>
                  .foo {
                    background: orange;
                  }
                </style>
                
              </head>
              <body>
                <h1 class="foo">Foo</h1>
              </body>
            </html>
      
      CSS - `:css`
      
          :css
          body, head {
            height: 100%;
            overflow: hidden;
          }
      
      Ruby - `:ruby` or `:rb`
      
          :ruby
          # Some ruby code.
          puts "Hello World!"
      
      C# - `:c#` or `:cs`
      
          :c#
          public class Foo<T> 
          {
            void Add(T value) { // ... }
          }
      
      Python - `:py` or `:python`
      
          :python
          from pygments import highlight
          from pygments.lexers import PythonLexer
          from pygments.formatters import HtmlFormatter

          code = 'print "Hello World"'
          print highlight(code, PythonLexer(), HtmlFormatter())      
      
      JSON - `:json` or `:js`
      
          :json
          {
            "name": "Foo",
            "version": "1.2.3".
            "dependencies": {
              "open.core": ">= 0.1.101"
            }
          }
      '''
  
  
  
  
  

  
  
  
  
  