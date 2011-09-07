module.exports = (core, Button) -> 
  
  ###
  A 'command' style button.
  ###
  class CommandButton extends Button
    constructor: (params) -> 
        super _.extend params, tagName:'button', className: 'core_btn_cmd'
        
    
    