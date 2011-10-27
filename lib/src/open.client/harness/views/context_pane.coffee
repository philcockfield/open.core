module.exports = (module) ->
  class ContextPaneView extends module.mvc.View
    defaults:
        height:    250 # Gets or sets the height of the panel (in pixels).
        minHeight: 38  # Gets or sets the minimum height of the panel (in pixels).
    
    constructor: (params = {}) -> 
        super className:'th_context_pane'
        @render()
    
    
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
  
  
