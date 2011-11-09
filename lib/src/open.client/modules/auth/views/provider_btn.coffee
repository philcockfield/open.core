###
A button that represents an Authentication Provider
hosted within the [SignIn] control.
###
module.exports = (module) ->
  class ProviderButton extends module.controls.Button
    constructor: (params = {}) -> 
        # Setup initial conditions.
        super _.extend params, className: 'core_provider_btn', canToggle:true
        @render()
        
        # Wire up events.
        @value.onChanged => @updateState()
        
    
    
    render: -> 
        @html new Tmpl().root()
        @divLogo = @$ '.core_logo'
        @updateState()
    
    
    updateState: -> 
        PREFIX = 'core_provider_'
        div = @divLogo
        
        # Remove provider classes.
        for name in div.get(0).className.split(' ')
          div.removeClass name if _(name).startsWith PREFIX
        
        # Add provider logo class.
        div.addClass PREFIX + @value()
        
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  class Tmpl extends module.mvc.Template
    root:
      """
      <div class="core_inner_border">
        <div class="core_logo"></div>
      </div>      
      """
  
  
  # Export.
  ProviderButton
