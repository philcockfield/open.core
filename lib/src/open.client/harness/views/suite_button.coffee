module.exports = (module) ->
  class SuiteButton extends module.controls.Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, tagName: 'li', className: 'th_suite_btn', canToggle:true
        @model = options.model
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => 
              # Ensure the button is selected if the model is set as the selected suite.
              @selected(true) if e.newValue is @.model
        
        # Finish up.
        updateState @
    
    
    render: -> 
        
        # Render base HTML.
        @html module.tmpl.suiteButton model: @model
        
        renderChildSuites = (elParent, model) ->
            return if model.childSuites.length is 0
            
            # Insert the containing UL.
            ul = $('<ul class="th_sub_suites"></ul>')
            elParent.append ul
            
            # Enumerate each child spec.
            model.childSuites.each (d) ->
                li = $("<li class='th_suite th_child'></li>")
                li.html $("<p>#{d.title()}</p>")
                
                d.init()
                renderChildSuites li, d # <== Recursion.
                
                
                
                ul.append li
            
            
            
        renderChildSuites @el, @model
        
        # Finish up.
        @ulChildSuites = @el.children('ul.th_sub_suites')
        
        # Render child suites.
    
    
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
          module.selectedSuite view.model if view.selected()
  
  
  # Export.
  SuiteButton
  

        