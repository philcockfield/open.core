module.exports = (module) ->
  class SpecButton extends module.controls.Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, className: 'th_spec th_btn', canToggle:true
        @model = options.model
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Wire up events.
        @el.mouseup => 
              # On mouseup invoke the spec (via the model).
              # Use the element's [mouseup] event, rather that [onClick] because
              # we want to catch each click, not just when the button becomes selected 
              # (which shows the blue disc meaning - "this was the last spec that was invoked").
              @model.invoke() if @enabled()
        
        module.selectedSpec.onChanged (e) => 
              # Ensure the button is selected if the model is set as the selected spec.
              @selected(true) if e.newValue is @.model
        
        # Finish up.
        updateState @
    
    
    render: -> 
        text = _(@model.description()).capitalize()
        @html module.tmpl.specButton text:text
    
    
    handleSelectedChanged: -> updateState @
  
  
  # PRIVATE --------------------------------------------------------------------------  
  
  
  updateState = (view) ->
          
          # Store the selection on the TestHarness root.
          module.selectedSpec view.model if view.selected()
  
  
  # Export.
  SpecButton
  

        