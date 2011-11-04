module.exports = (module) ->
  class Root extends module.mvc.View
    constructor: () -> 
        super className: @_className('auth_root')
        @render()
    
    
    render: -> 
        @html 'Root'
        