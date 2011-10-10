module.exports = (module) ->
  class SuiteButton extends module.controls.Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, tagName: 'li', className: 'th_desc_btn', canToggle:true
        @model = options.model
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Finish up.
        updateState @
    
    
    render: -> 
        
        # Render base HTML.
        @html module.tmpl.suiteButton model: @model
        @ulChildSuites = @$('ul.th_sub_descriptions')
        
        # Render child descriptions.
        @model.childSuites.each (d) =>
            li = $("<li class='th_desc th_child'>#{d.title()}</li>")
            @ulChildSuites.append li
    
    
    handleSelectedChanged: -> updateState @
  
  
  # PRIVATE --------------------------------------------------------------------------  
  
  
  updateState = (view) ->
          
          # Initialize the model.
          if view.selected() and not view.model.isInitialized is yes
              view.model.init() 
              view.render()
        
          # Show or hide the list of child-suites.
          view.ulChildSuites.toggle (view.selected() and view.model.childSuites.length > 0)
          
          # Store the selection on the TestHarness root.
          module.selectedDescription view.model if view.selected()
  
  
  # Export.
  SuiteButton
  

        