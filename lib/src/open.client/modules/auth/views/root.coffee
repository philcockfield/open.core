###
The root authentication view.

Events:
 - click:signIn - Fires when the sign in button is selected (bubbled from the [SignIn] control).

###
module.exports = (module) ->
  class Root extends module.mvc.View
    constructor: () -> 
        # Setup initial conditions.
        super className: @_className('auth_root')
        
        # Wire up events.
        module.mode.onChanged => @updateState()
        module.core.bind 'window:resize', => @_syncStyles()
        
        # Finish up.
        @updateState()
    
    
    signIn: -> 
        return @_signIn if @_signIn?
        signIn = new module.views.SignIn().append(@el).init [
          { value:'facebook' }
          { value:'google' }
          { value:'twitter' }
          { value:'yahoo' }
          { value:'linked_in', label: 'Linked In' }
        ]
        @bubble 'click:signIn', signIn
        @_signIn = signIn
    
    
    # Updates the visual state of the module.
    updateState: -> 
        
        # Setup initial conditions.
        signIn = @signIn()
        
        # Show hide controls based on the current mode.
        switch module.mode()
          when 'sign_in'
            signIn.visible true
          else
            signIn.visible false
        
        # Finish up.
        @_syncStyles()
    
    
    # PRIVATE --------------------------------------------------------------------------
    
    
    _syncStyles: -> 
        
        # Ensure the sign-in control does not fall off the top of the screen.
        signIn = @_signIn
        if signIn?
          MIN_TOP = 20
          top = signIn.el.offset().top
          if top isnt 0 and top < MIN_TOP
              signIn.el.css 'margin-top', '0px'
              signIn.el.css 'top', MIN_TOP + 'px'
          else
              signIn.el.css 'margin-top', '-170px'
              signIn.el.css 'top', '50%'
        
        
        