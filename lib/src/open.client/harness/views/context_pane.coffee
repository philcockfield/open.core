module.exports = (module) ->
  class ContextPaneView extends module.mvc.View
    constructor: (params = {}) -> 
        
        # Setup initial conditions.
        super className:'th_context_pane'
        # @model = params.model
        @render()
        
        # Syncers.
        # syncVisibility = => @visible @model.visible()
        
        # Wire up events.
        # @model.visible.onChanged syncVisibility
        
        # Finish up.
        # syncVisibility()
    
    
    # Shows the pane by setting the [visible] property to true.
    show: -> @visible true
    
    
    # Hides the pane by setting the [visible] property to false.
    hide: -> @visible false
    
    
    render: -> 
        @html module.tmpl.contextPane()
        @tabStrip = new module.controls.TabStrip().replace @$('.th_tab_strip')
        
        # TEMP 
        @tabStrip.add label:'One'
        @tabStrip.add label:'Two'
        @tabStrip.add label:'Three'
        @tabStrip.first().click()
  
  
