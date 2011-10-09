module.exports = (module) ->
  class SidebarView extends module.mvc.View
    constructor: () -> 
        super className: 'th_sidebar'
        @render()
        
        console.log '@', @
        
        renderDescriptions @
    
    
    render: -> 
        @tmpl = new module.views.Tmpl()
        @html @tmpl.sidebar()
        


# PRIVATE --------------------------------------------------------------------------


  renderDescriptions = (view) -> 

      # Setup initial conditions.
      ul = view.$('ul.th_descs')
      ul.empty()
      
      
      module.descriptions.each (d) -> 
          li = $('<li class="th_desc"></li>')
          li.append d.title()
          ul.append li
        
    
      console.log 'ul', ul
    
    
    
    
    
  # Export.
  SidebarView


    