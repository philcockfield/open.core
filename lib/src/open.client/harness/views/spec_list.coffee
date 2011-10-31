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
        @html module.tmpl.specList title: 'Specs'
        @$('.th_title_bar').disableTextSelect()
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
            @buttons.add btn
            
            # Append it to the UL within a LI.
            li = $('<li class="th_btn">')
            li.append btn.el
            ul.append li
