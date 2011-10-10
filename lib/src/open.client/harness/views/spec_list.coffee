module.exports = (module) ->
  class SpecList extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_specs_list'
        @render()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => 
            @renderSpecs()
    
    
    render: -> 
        @html module.tmpl.specList()
        @renderSpecs()
        
    
    renderSpecs: () -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        return unless suite?
        
        # Clear the UL.
        ul = @$('ul')
        ul.empty()
        
        # Insert each spec.
        module.selectedSuite().specs.each (spec) -> 
            li = $("<li>#{spec.description()}</li>")
            ul.append li
        
    
    