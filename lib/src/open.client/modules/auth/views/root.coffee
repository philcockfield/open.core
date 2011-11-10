module.exports = (module) ->
  class Root extends module.mvc.View
    constructor: () -> 
        super className: @_className('auth_root')
        @render()
    
    
    render: -> 
        @signIn = new module.views.SignIn().append(@el).init [
          { value:'facebook' }
          { value:'google' }
          { value:'twitter' }
          { value:'yahoo' }
          { value:'linked_in', label: 'Linked In' }
        ]
        
        
        
        