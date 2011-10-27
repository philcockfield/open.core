module.exports = (module) ->
  class ContextPaneView extends module.mvc.View
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        super className:'th_context_pane'
        @model = params.model
        @render()
        
        # Syncers.
        syncVisibility = => @visible @model.visible()
        
        # Wire up events.
        @model.visible.onChanged syncVisibility
        
        # Finish up.
        syncVisibility()
        
    
    render: -> 
        
        
        
        
        @html 'Context!'
    
    
    