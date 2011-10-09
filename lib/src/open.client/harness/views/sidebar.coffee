module.exports = (module) ->
  DescButton = module.view 'desc_button'
  
  class SidebarView extends module.mvc.View
    constructor: () -> 
        super className: 'th_sidebar'
        @buttons = new module.controls.ButtonSet()
        @render()
        renderDescriptions @
    
    
    render: -> @html module.tmpl.sidebar()


# PRIVATE --------------------------------------------------------------------------


  renderDescriptions = (view) -> 

      # Setup initial conditions.
      ul = view.$('ul.th_descriptions')
      ul.empty()
      view.buttons.clear()
      
      # Enumerate each root 'description'.
      module.descriptions.each (d) -> 
          
          # Create the Description-button.
          btn = new DescButton model:d
          view.buttons.add btn
          
          # Insert into the list.
          ul.append btn.el
      
      # Select the first button.
      view.buttons.items.first().selected true
      
      
    
    
  # Export.
  SidebarView


    