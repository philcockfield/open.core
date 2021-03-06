###
An authentiation provider selector.

Events:
 - click:signIn - Fires when the sign in button is selected.

###
module.exports = (module) ->
  cookie = module.cookie
  
  class SignIn extends module.mvc.View
    constructor: () -> 
        # Setup initial conditions.
        super className:"core_sign_in core_inset_pane"
        @render()
        @el.disableTextSelect()
        @providers = new module.controls.ButtonSet()
        
        # Wire up events.
        @enabled.onChanged => @_syncEnabled()
        @providers.bind 'selectionChanged', => 
            cookie.provider (@selected()?.value() ? null)
            @_syncTitle()
        @btnSignIn.onClick => @_fireSignIn()
        
        # Finish up.
        @_syncTitle()
        @_syncEnabled()
    
    
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
    
    
    ###
    Adds a collection of providers.
    @param providers : An array of button options.  See [addProvider] method.
    ###
    init: (providers = []) -> 
        @addProvider p for p in providers
        @
    
    
    ###
    Adds a new Authentication Provider button.
    @param options - button options for the provider.  Specify at least 'value', and optionally a 'label'
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
        options.enabled = @enabled()
        btn = new module.views.ProviderButton options
        btn.el.dblclick => @_fireSignIn()
        @providers.add btn
        addCell().append btn.el
        
        # Select the button (if required).
        savedProvider = cookie.provider()
        if savedProvider?
          btn.selected true if options.value is savedProvider
        else
          # No previous selection stored in cookie.
          # Select if this is the first provider.
          btn.selected true if @providers.count() is 1
        
        # Finish up.
        # btn.selected true if @providers.count() is 1
        btn
    
    
    # PRIVATE --------------------------------------------------------------------------
    
    
    _fireSignIn: -> 
        return unless @enabled() is yes
        @trigger 'click:signIn', selected:@selected() 
    
    
    _syncTitle: -> 
        selected = @selected()
        
        # Build title text.
        title = "Sign In With "
        if selected?
          provider = selected.label()
          if provider? is false or _(provider).isBlank()
            provider = _(selected.value()).capitalize()
          title += provider
          
        # Update the DOM.
        @divTitle.html title
    
    
    _syncEnabled: -> 
        isEnabled = @enabled()
        
        # Update enabled state of each provider button.
        @providers.items.map (btn) -> btn.enabled isEnabled
        
        # Update the sign-in button.
        @btnSignIn.enabled isEnabled
    
  
  
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
  
  
