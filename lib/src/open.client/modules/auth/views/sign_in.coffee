###
An authentiation provider selector.

Events:
 - click:signIn - Fires when the sign in button is selected.

###
module.exports = (module) ->
  class SignIn extends module.mvc.View
    constructor: () -> 
        # Setup initial conditions.
        super className:"core_auth_sign_in core_inset_pane core_shadow_x_8px"
        @render()
        @el.disableTextSelect()
        @providers = new module.controls.ButtonSet()
        
        # Wire up events.
        @providers.bind 'selectionChanged', (e) => @syncTitle()
        @btnSignIn.onClick => @trigger 'click:signIn', selected:@selected()
        
        # Finish up.
        @syncTitle()
    
    # Gets the currently selected provider.
    selected: -> @providers.selected()
    
    render: -> 
        # Insert base HTML structure.
        @html new Tmpl().root()
        @divTitle       = @$ '.core_title'
        @tableProviders = @$ '.core_providers'
        
        
        # Insert buttons.
        @btnSignIn = 
          new module.controls.CmdButton( label:'Sign In', color:'blue' )
          .replace @$ '.core_btn_sign_in'
    
    
    syncTitle: -> 
        selected = @selected()
        title = "Sign In With "
        title += selected.label() if selected?
        @divTitle.html title
    
    
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
        btn = new module.views.ProviderButton options
        @providers.add btn
        addCell().append btn.el
        
        # Finish up.
        btn.selected true if @providers.count() is 1
        btn
  
  
  class Tmpl extends module.mvc.Template
    root:
      """
      <div class="core_title"></div>
      <div class="core_body">
        <table class="core_providers"></table>
      </div>
      <div class="core_footer">
        <button class="core_btn_sign_in"></button>
      </div>
      """
  
  
  # Export.
  SignIn
  
  