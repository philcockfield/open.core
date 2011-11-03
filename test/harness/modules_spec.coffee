describe 'Modules', ->
  describe 'Auth', 'Authentication and authorization UI module.', ->
    Auth = null
    auth = null
    beforeAll ->
        Auth = require 'open.client/auth'
        auth = new Auth()
        auth.init()
        page.add auth.rootView, fill:true, border:true
    
    
    describe 'Sign In', ->
      signIn = null
      
      beforeAll ->
        signIn = new auth.views.SignIn()
        page.reset()
        page.add signIn.el
        
        signIn.addProvider label:'Facebook'
        signIn.addProvider label:'Google'
        signIn.addProvider label:'Twitter'
        signIn.addProvider label:'Yahoo'
        signIn.addProvider label:'Dropbox'
      
    
    
    
  