###
Renders a vertical list of input fields with labels.
###
module.exports = (module) ->
  class Form extends module.mvc.View
    constructor: (args = {}) -> 
        super _.extend args, className:@_className('form')
        @render()
    
    
    render: -> @html new Tmpl().root()
  
  
  class Tmpl extends module.mvc.Template
    root:
      """
      Form!    
      """
  
  # Export.
  Form
