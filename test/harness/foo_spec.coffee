describe 'Foo', 
    '''
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    ''', 
    ->
      
      describe 'A', ->
        beforeAll -> 
              console.log '++ Before All: A' # Create and insert view here.

              el = $('<div class="foo">Hello I am an element.</div>')
              
              options = 
                  width: '80%'
                  height: '60%'
                  # css: '/stylesheets/dev/test.css'
                  # showTitle: false

              page.css '/stylesheets/dev/test.css'
              
              page.add el, options
              
              
              
        afterAll  -> console.log '++ After All: A'
            
        beforeEach -> console.log '+ Before Each: A'
        afterEach  -> console.log '- After Each: A'
      
        describe 'B', ->

            beforeAll -> console.log '++ Before All: B' 
            afterAll  -> console.log '++ After All: B'

            beforeEach -> console.log '+ Before Each: B'
            afterEach  -> console.log '- After Each: B'
              
            describe 'C', ->
              beforeEach -> console.log '+ Before Each: C'
              afterEach  -> console.log '- After Each: C'
          
              it 'Does It', ->
                console.log 'Spec C'
              
                
              
              
          
              

# 
# 
# describe 'Really Long Name that Should Overflow by all accounts'
# 
# 
# describe 'Foo34', 'Foo3-Summary'
  
  

    
  