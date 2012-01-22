
module.exports = (module) ->
  class Root extends module.mvc.View
    constructor: -> 
        super className: 'th_harness'
        @render()
    
    
    render: -> 
        # Insert base HTML structure.
        tmpl = module.tmpl
        @html tmpl.root()
        
        # Insert sub-views.
        Sidebar  = module.view 'sidebar'
        @sidebar = new Sidebar().replace @$('.th_sidebar')
        
        Main  = module.view 'main'
        @main = new Main().replace @$('.th_main')
        
        
        
