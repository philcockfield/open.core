module.exports = (module) ->
  class SignIn extends module.mvc.View
    constructor: () -> 
        super className:"core_auth_sign_in core_inset_pane core_shadow_x_8px"
        @render()
        @el.disableTextSelect()
    
    render: -> 
        # Insert base HTML structure.
        @html new Tmpl().root()
        
        # Insert buttons.
        @btnSignIn = 
          new module.controls.CmdButton( label:'Sign In', color:'blue' )
          .replace @$ '.core_btn_sign_in'
  
  
  class Tmpl extends module.mvc.Template
    root:
      """
      <div class="core_title">Sign In</div>
      <div class="core_body"></div>
      <div class="core_footer">
        <button class="core_btn_sign_in"></button>
      </div>
      """
  
  
  # Export
  SignIn
  
  
  