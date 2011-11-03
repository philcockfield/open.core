describe 'Modules', ->
  describe 'Auth', 'Authentication and authorization UI module.', ->
    Auth = null
    auth = null
    beforeAll ->
        Auth = require 'open.client/auth'
        auth = new Auth()
        auth.init()
        page.add auth.rootView, fill:true
    
    
    describe 'Sign In', ->
      beforeAll ->
        page.reset()
      
    
    
    
  