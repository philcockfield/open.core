module.exports = (module) ->
  SpecButton = module.view 'spec_button'
  
  class SpecList extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_spec_list'
        @buttons = new module.controls.ButtonSet()
        @render()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @renderList()
    
    
    render: -> 
        @html module.tmpl.specList()
        @renderList()
    
    renderList: () -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        return unless suite?
        
        # Clear the UL.
        ul = @$('ul')
        ul.empty()
        @buttons.clear()
        
        # Enumerate each spec.
        suite.specs.each (spec) => 
            
            # Create the button.
            btn = new SpecButton model:spec
            @buttons.add btn
            
            # Insert into the list.
            ul.append btn.el
