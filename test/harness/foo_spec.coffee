describe 'Foo', 
    '''
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vel eleifend nisl. Suspendisse tristique dignissim leo ut auctor.
    ''', 
    ->
    
      beforeEach -> console.log 'Before each: FOO 1'
      beforeEach -> console.log 'Before each: FOO 2'
    
      afterEach -> console.log 'After each: FOO'
    
      beforeAll -> console.log 'Before all: FOO'
      afterAll -> console.log 'After all: FOO'
    
      it 'Adds something to the Test Harness', ->
          el = $('<div>Hello I am an element.</div>')
          page.add el
        
      it 'Clears the Test Harness', -> page.clear()
    
      it 'Throws an error', -> throw 'My Error!!!!'
    
      describe 'foo-child', ->
        it 'foo-child spec', ->
          console.log 'foo-child sec output'
        describe 'foo-grand-child', ->
          describe 'fooo-great-grand-child', ->



describe 'Really Long Name that Should Overflow by all accounts'


describe 'Foo34', 'Foo3-Summary'
  
  

    
  