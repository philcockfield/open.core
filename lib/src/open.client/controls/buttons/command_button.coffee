module.exports = (core, Button) -> 
  
  ###
  A 'command' style button.
  ###
  class CommandButton extends Button
    constructor: (params = {}) -> 
        super _.extend params, tagName: 'button', className: 'core_cmd'
        @render()
        
    
    render: -> 
      @html @label()
    



    