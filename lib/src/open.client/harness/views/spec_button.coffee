module.exports = (module) ->
  class SpecButton extends module.controls.Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, tagName: 'li', className: 'th_spec_btn'
        @model = options.model
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Wire up events.
        @onClick => @model.invoke()
        module.selectedSpec.onChanged (e) => 
              # Ensure the button is selected if the model is set as the selected spec.
              @selected(true) if e.newValue is @.model
        
        # Finish up.
        updateState @
    
    
    render: -> @html module.tmpl.specButton model: @model
    
    
    handleSelectedChanged: -> updateState @
  
  
  # PRIVATE --------------------------------------------------------------------------  
  
  
  updateState = (view) ->
          
          # Initialize the model.
          # if view.selected() and not view.model.isInitialized is yes
          #     view.model.init() 
          #     view.render()
          #         
          # # Show or hide the list of child-suites.
          # view.ulChildSuites.toggle (view.selected() and view.model.childSuites.length > 0)
          # 
          # Store the selection on the TestHarness root.
          module.selectedSpec view.model if view.selected()
  
  
  # Export.
  SpecButton
  

        