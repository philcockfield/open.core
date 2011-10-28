module.exports = (module) ->
  class Sidebar extends module.mvc.View
    
    constructor: () -> 
        super className: 'th_sidebar'
        @render()
        @el.disableTextSelect()
    
    
    render: -> 
        
        # Insert the 'description' list.
        SuiteList = module.view 'suite_list'
        @suiteList = new SuiteList()
        @el.append @suiteList.el
        
        # Insert the 'sepc' list.
        SpecList = module.view 'spec_list'
        @specList = new SpecList()
        @el.append @specList.el
        


# PRIVATE --------------------------------------------------------------------------


  # Export.
  Sidebar


    