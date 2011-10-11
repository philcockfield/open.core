module.exports = (module) ->
  SpecButton = module.view 'spec_button'
  
  class SpecList extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_spec_list'
        @render()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @renderList()
    
    
    render: -> 
        @html module.tmpl.specList title: 'Specs'
        @renderList()
    
    
    renderList: () -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        return unless suite?
        
        # Clear the UL.
        ul = @$('ul')
        ul.empty()
        
        # Enumerate each spec.
        suite.specs.each (spec) => 
            
            # Create the button and insert it into the list.
            btn = new SpecButton model:spec
            ul.append btn.el
