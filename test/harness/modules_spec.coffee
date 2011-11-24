describe 'Modules', ->
  describe 'Auth', 'Authentication and authorization UI module.', ->
    Auth = null
    auth = null
    views = null
    beforeAll ->
        Auth  = require 'open.client/auth'
        auth  = new Auth( mode:'sign_in' ).init()
        views = auth.views
        page.add auth.rootView, fill:true, border:true
    
    it 'Mode: sign_in', -> auth.mode 'sign_in'
    it 'Mode: null',    -> auth.mode null
    
    
    describe 'Sign In', ->
      signIn = null
      beforeAll ->
        signIn = new auth.views.SignIn()
        page.add signIn.el, reset:true
        
        signIn.bind 'click:signIn', (e) -> console.log 'click:signIn - ', e.selected.value(), e
        signIn.init [
          { value:'facebook' }
          { value:'google' }
          { value:'twitter' }
          { value:'yahoo' }
          { value:'linkedin', label: 'Linked In' }
        ]
      it 'Toggle: Enabled', -> signIn.enabled.toggle()
    
    
    describe 'Provider Button', ->
      btn = null
      beforeAll ->
        btn = new views.ProviderButton value:'facebook'
        page.add btn, reset:true, width:147, height:56-11
      
      it 'Toggle: Enabled',     -> btn.enabled.toggle()
      it 'Toggle: Selected',    -> btn.selected.toggle()
      it 'Provider: Facebook',  -> btn.value 'facebook'
      it 'Provider: Google',    -> btn.value 'google'
      it 'Provider: Twitter',   -> btn.value 'twitter'
      it 'Provider: Yahoo',     -> btn.value 'yahoo'
      it 'Provider: Linked In', -> btn.value 'linkedin'
        
      
        
      
        
      
      
          
      
    
      
    
    
    
  