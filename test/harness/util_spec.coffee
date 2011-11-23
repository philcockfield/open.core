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
      console.log ''
      
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
          
    it 'Read: foo', -> 
      value = cookie.foo()
      console.log 'cookie.foo(): ', value
      console.log 'Is Null: ', not value?
      console.log ''
    it 'Write: foo', -> cookie.foo new Date().getTime()
    it 'Write: foo (null)', -> cookie.foo null
    it 'Write: foo (empty-string)', -> cookie.foo ''
    it 'Write: foo (multiple times)', -> cookie.foo i for i in [0..10]
    it 'Delete', -> cookie.delete()
    it 'document.cookie', -> console.log 'document.cookie: ', document.cookie



