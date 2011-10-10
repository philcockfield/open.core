module.exports = (module) ->
  class SpecListView extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_specs_list'
        @render()
        
        # Wire up events.
        module.selectedDescription.onChanged (e) -> 
            
            console.log 'e', e, e.newValue.title()
            
            # if e.newValue == true
            # 
            #   console.log 'e', e 
        
    
    
    render: -> 
        @html module.tmpl.specList()
    