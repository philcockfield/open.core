module.exports = (module) ->
  SuiteButton = module.view 'suite_button'

  class SuiteList extends module.mvc.View
    constructor: () -> 
        super className: 'th_desc_list'
        @buttons = new module.controls.ButtonSet()
        @render()
    
    render: -> 
        @html module.tmpl.suiteList()
        @renderList()          
    
    renderList: -> 
        # Setup initial conditions.
        ul = @el.children('ul')
        ul.empty()
        @buttons.clear()
      
        # Enumerate each root 'suite'.
        module.suites.each (d) => 
          
            # Create the button.
            btn = new SuiteButton model:d
            @buttons.add btn
          
            # Insert into the list.
            ul.append btn.el
    
