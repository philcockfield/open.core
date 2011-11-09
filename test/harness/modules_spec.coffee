describe 'Modules', ->
  describe 'Auth', 'Authentication and authorization UI module.', ->
    Auth = null
    auth = null
    views = null
    beforeAll ->
        Auth  = require 'open.client/auth'
        auth  = new Auth().init()
        views = auth.views
        page.add auth.rootView, fill:true, border:true
    
    
    describe 'Sign In', ->
      signIn = null
      
      beforeAll ->
        signIn = new auth.views.SignIn()
        signIn.bind 'click:signIn', (e) -> console.log 'click:signIn - ', e.selected.label(), e
        page.reset()
        page.add signIn.el
        
        signIn.addProvider value:'facebook'
        signIn.addProvider value:'google'
        signIn.addProvider value:'twitter'
        signIn.addProvider value:'yahoo'
        signIn.addProvider value:'linked_in'
    
    describe 'Provider Button', ->
      btn = null
      beforeAll ->
        btn = new views.ProviderButton value:'facebook'
        page.reset()
        page.add btn, width:147, height:56-11
      
      it 'Select',            -> btn.selected true
      it 'Deselect',          -> btn.selected false
      it 'Toggle: Selected',  -> btn.selected.toggle()
        
      
        
      
      
          
      
    
      
    
    
    
  