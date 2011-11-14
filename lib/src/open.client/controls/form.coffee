core = require '../core'

###
Renders a vertical list of input fields with labels.
###
module.exports = class Form extends core.mvc.View
  constructor: (args = {}) -> 
      super _.extend args, className:@_className('form')
      @render()
  
  
  render: -> @html new Tmpl().root()
    



class Tmpl extends core.mvc.Template
  root:
    """
    Form!    
    """
    
  
