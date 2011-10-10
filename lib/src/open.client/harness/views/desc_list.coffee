module.exports = (module) ->
  DescButton = module.view 'desc_button'

  class DescriptionListView extends module.mvc.View
    constructor: () -> 
        super className: 'th_desc_list'
        @buttons = new module.controls.ButtonSet()
        @render()
        renderDescriptions @
    
    render: -> @html module.tmpl.descriptionList()


# PRIVATE --------------------------------------------------------------------------


  renderDescriptions = (view) -> 

      # Setup initial conditions.
      ul = view.el.children('ul')
      ul.empty()
      view.buttons.clear()
      
      # Enumerate each root 'description'.
      module.suites.each (d) -> 
          
          # Create the Description-button.
          btn = new DescButton model:d
          view.buttons.add btn
          
          # Insert into the list.
          ul.append btn.el
      
      # Select the first button.
      # NB: Timeout so that model correctly load child-descriptions.
      # setTimeout (-> view.buttons.items.first().selected true), 0
    
    
  # Export.
  DescriptionListView


    