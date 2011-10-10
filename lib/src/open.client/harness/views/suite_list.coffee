module.exports = (module) ->
  SuiteButton = module.view 'suite_button'

  class SuiteList extends module.mvc.View
    constructor: () -> 
        super className: 'th_desc_list'
        @buttons = new module.controls.ButtonSet()
        @render()
        renderSuites @
    
    render: -> @html module.tmpl.suiteList()


# PRIVATE --------------------------------------------------------------------------


  renderSuites = (view) -> 
      
      # Setup initial conditions.
      ul = view.el.children('ul')
      ul.empty()
      view.buttons.clear()
      
      # Enumerate each root 'description'.
      module.suites.each (d) -> 
          
          # Create the Description-button.
          btn = new SuiteButton model:d
          view.buttons.add btn
          
          # Insert into the list.
          ul.append btn.el
      
      # Select the first button.
      # NB: Timeout so that model correctly load child-suites.
      # setTimeout (-> view.buttons.items.first().selected true), 0
    
    
  # Export.
  SuiteList


    