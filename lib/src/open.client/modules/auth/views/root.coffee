module.exports = (module) ->
  class Root extends module.mvc.View
    constructor: () -> 
        super className: @_className('auth_root')
        module.mode.onChanged => @updateState()
        @updateState()
    
    
    signIn: -> 
        return @_signIn if @_signIn?
        @_signIn = new module.views.SignIn().append(@el).init [
          { value:'facebook' }
          { value:'google' }
          { value:'twitter' }
          { value:'yahoo' }
          { value:'linked_in', label: 'Linked In' }
        ]        
    
    
    # Updates the visual state of the module.
    updateState: -> 
        
        signIn = @signIn()
        
        # Update mode.
        switch module.mode()
          when 'sign_in'
            signIn.visible true
          else
            signIn.visible false
        
        
        
        
        
        
        