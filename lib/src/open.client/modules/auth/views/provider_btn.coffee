###
A button that represents an Authentication Provider
hosted within the [SignIn] control.
###
module.exports = (module) ->
  class ProviderButton extends module.controls.Button
    constructor: (params) -> 
        super _.extend params, className: 'core_provider_btn', canToggle:true
        @render()
    
    render: -> 
        @html new Tmpl().root()
        
        # TEMP 
        @$('.core_inner_border').html @label()  
  
  
  class Tmpl extends module.mvc.Template
    root:
      """
      <div class="core_inner_border"></div>      
      """
  
  
  # Export.
  ProviderButton
