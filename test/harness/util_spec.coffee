describe 'Util', ->
  describe 'Cookie', 'A wrapper for the browser cookie providing a consistent property-function API.', ->
    cookie = null
    beforeAll ->
      
      class MyCookie extends core.util.Cookie
        constructor: () -> super name:'stuff', expires:365 # days.
        defaults:
          foo: 123
          
      cookie = new MyCookie()
      
      console.log 'document.cookie: ', document.cookie
      console.log 'cookie.foo(): ', cookie.foo() # Read.
      
      page.pane.add.markdown
        label: 'Sample Code'
        markdown: 
          '''
              :coffee
              class MyCookie extends core.util.Cookie
                constructor: () -> super name:'stuff', expires:365 # days.
                defaults:
                  foo: 123
              
              cookie = new MyCookie()
              
              console.log 'cookie.foo(): ', cookie.foo() # Read.
              cookie.foo '456' # Write.
          
          '''
          
    it 'Read: foo', -> console.log 'cookie.foo()', cookie.foo()
    it 'Write: foo', -> cookie.foo new Date().getTime()
    it 'Write: foo (multiple times)', -> cookie.foo i for i in [0..10]
      
    it 'document.cookie', -> console.log 'document.cookie: ', document.cookie
      
    
    
    
    it 'TEMP', ->
      
      foo = new core.util.Cookie name:'bar1'
      
      # document.cookie = 'bar={"foo":456}; expires=10000; path=/'
      # document.cookie = 'bar=; expires=-1; path=/'
      
    
        
      
      
      
      
      
    
    
  