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
        
        # Syncers
        syncLogoClasses = => 
          @divLogo.toggleClass 'core_enabled', @enabled()
        
        # Wire up events.
        @value.onChanged => @updateState()
        @enabled.onChanged syncLogoClasses
        
        # Finish up.
        syncLogoClasses()
    
    
    render: -> 
        @html new Tmpl().root()
        @divLogo = @$ '.core_logo'
        @updateState()
    
    
    handleStateChanged: -> @updateState()
    
    updateState: -> 
        PREFIX     = 'core_provider_'
        div        = @divLogo
        isSelected = @selected()
        
        # Remove provider classes.
        for name in div.get(0).className.split(' ')
          div.removeClass name if _(name).startsWith PREFIX
        
        # Add provider logo class.
        div.addClass PREFIX + @value()
        
        # Toggle gray-scale class.
        isColored = @selected() or @over()
        div.toggleClass 'core_color', isColored
        # div.toggleClass 'core_over', @over()
        
        
  
  
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
