module.exports = (module) ->
  ###
  An authentiation provider selector.
  ###
  class SignIn extends module.mvc.View
    constructor: () -> 
        super className:"core_auth_sign_in core_inset_pane core_shadow_x_8px"
        @render()
        @el.disableTextSelect()
        @providers = new module.controls.ButtonSet()
    
    render: -> 
        # Insert base HTML structure.
        @html new Tmpl().root()
        @tableProviders = @$ '.core_providers'
        
        # Insert buttons.
        @btnSignIn = 
          new module.controls.CmdButton( label:'Sign In', color:'blue' )
          .replace @$ '.core_btn_sign_in'
    
    ###
    Adds a new Authentication Provider button.
    @param options
    @returns the new button.
    ###
    addProvider: (options = {}) -> 
        
        # Table functions.
        table = @tableProviders
        addRow = => 
            row = $ '<tr>'
            table.append row
            @_row = row
            row
        
        currentRow = => 
            row = @_row
            row = addRow() if row? is false or row.children().length is 3
            row
        
        addCell = => 
            td = $ '<td>'
            currentRow().append td
            td
        
        # Create the buttons.
        btn = new ProviderBtn options
        @providers.add btn
        addCell().append btn.el
        
        # Finish up.
        btn
  
  
  ###
  A button that represents an Authentication provider.
  ###
  SignIn.ProviderBtn = class ProviderBtn extends module.controls.Button
    constructor: (params) -> 
        super _.extend params, className: 'core_provider_btn', canToggle:true
        @render()
    
    render: -> 
        @html new Tmpl().providerBtn()
        
        # TEMP 
        @html @label()
        
  
  class Tmpl extends module.mvc.Template
    root:
      """
      <div class="core_title">Sign In With</div>
      <div class="core_body">
        <table class="core_providers"></table>
      </div>
      <div class="core_footer">
        <button class="core_btn_sign_in"></button>
      </div>
      """
    
    providerBtn:
      """
      Provider      
      """
      
  
  
  # Export
  SignIn
  
  
