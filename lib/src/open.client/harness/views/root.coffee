core = require 'open.client/core'

module.exports = (module) ->
  class RootView extends core.mvc.View
    constructor: -> 
        super className: 'th_harness'
        @render()
    
    
    render: -> 
        
        # Insert base HTML structure.
        tmpl = new module.views.Tmpl()
        @html tmpl.root()
    