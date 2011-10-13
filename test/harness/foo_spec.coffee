describe 'A', 
    '''
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    ''', 
    ->
      # beforeAll -> 
      #     el = $('<div>Hello I am an element.</div>')
      #     el.css 'width', '300px'
      #     # el.css 'background', 'orange'
      #     el.css 'height', '100%'
      #     page.add el
      #     console.log 'el', el
      # 
      # afterAll -> console.log 'After all: FOO'
      # 
      # beforeEach -> 
      # afterEach -> console.log 'After each: FOO'
      
      
      # it 'Adds something to the Test Harness', ->
      # it 'Clears the Test Harness', -> page.clear()
      # it 'Throws an error', -> throw 'My Error!!!!'
      
      beforeEach -> console.log 'Before A'
          
      
      describe 'B', ->
          beforeEach -> console.log 'Before B'
              
          describe 'C', ->
            beforeEach -> console.log 'Before C'
          
            it 'Does It', ->
              console.log 'Spec C'
          
              



describe 'Really Long Name that Should Overflow by all accounts'


describe 'Foo34', 'Foo3-Summary'
  
  

    
  