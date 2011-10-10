module.exports = (module) ->
  class SpecListView extends module.mvc.View
    constructor: () -> 
        
        # Setup initial conditions.
        super className: 'th_specs_list'
        @render()
        
        # Wire up events.
        module.selectedDescription.onChanged (e) => 
            
            # suite = e.newValue
            # 
            # console.log 'suite', suite.its.length, suite.title()
            # suite.its.each (spec) ->  
            #     console.log ' > ', spec.description()
            # console.log ''
            
            
            @renderSpecs()
            
            # console.log 'e', e, e.newValue.title()
            
        
    
    
    render: -> 
        @html module.tmpl.specList()
        @renderSpecs()
        
    
    renderSpecs: () -> 
        
        # Setup initial conditions.
        suite = module.selectedDescription()
        return unless suite?
        
        # Clear the UL.
        ul = @$('ul')
        ul.empty()
        
        # Insert each spec.
        module.selectedDescription().its.each (spec) -> 
            
            li = $("<li>#{spec.description()}</li>")
            
            ul.append li
            
        
        
        
    
    