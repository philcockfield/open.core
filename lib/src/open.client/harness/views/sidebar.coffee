module.exports = (module) ->
  class SidebarView extends module.mvc.View
    constructor: () -> 
        super className: 'th_sidebar'
        @render()
    
    
    render: -> 
        
        # Insert the 'description' list.
        DescriptionList = module.view 'desc_list'
        @descriptionList = new DescriptionList()
        @el.append @descriptionList.el
        
        # Insert the 'sepc' list.
        SpecList = module.view 'spec_list'
        @specList = new SpecList()
        @el.append @specList.el
        
        


# PRIVATE --------------------------------------------------------------------------


  # Export.
  SidebarView


    