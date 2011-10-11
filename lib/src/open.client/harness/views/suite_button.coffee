module.exports = (module) ->
  class SuiteButton extends module.controls.Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, tagName: 'li', className: 'th_suite_btn', canToggle:true
        @model = options.model
        @model.init()
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => 
                    # Ensure the button is selected if the model is set as the selected suite.
                    @selected(true) if e.newValue is @.model
        
        # Finish up.
        @_updateState()
    
    
    render: -> 
        
        # Render base HTML.
        @html module.tmpl.suiteButton model: @model
        
        renderChildSuites = (elParent, model) ->
            return if model.childSuites.length is 0
            
            # Insert the containing UL.
            ul = $('<ul class="th_sub_suites"></ul>')
            elParent.append ul
            
            # Enumerate each child spec.
            model.childSuites.each (suite) ->
                      # Insert the LI.
                      title = _(suite.title()).capitalize()
                      li    = $("<li class='th_suite th_child'></li>")
                      li.html $("<p>#{title}</p>")
                      
                      # Insert child suites in a new child UL.
                      suite.init()
                      renderChildSuites li, suite # <== Recursion.
                      
                      # Insert the LI into the UL
                      ul.append li
        
        # Render any child-suites that may exist.
        renderChildSuites @el, @model
        
        # Finish up.
        @ulChildSuites = @el.children('ul.th_sub_suites')
    
    
    handleSelectedChanged: -> @_updateState true
    
    
    _updateState: (animate = false) -> 
          
          # Setup initial conditions.
          isSelected = @selected()
          
          # Show or hide the list of child-suites.
          aniToggle = (el, show, duration = 100) -> if show then el.show(duration) else el.hide(duration)
          do => 
              ul   = @ulChildSuites
              show = (isSelected and @model.childSuites.length > 0 and ul.is(':hidden'))
              if animate
                  aniToggle ul, show
              else
                ul.toggle show
          
          # Store the selection on the TestHarness root.
          module.selectedSuite(@model) if @selected()
  
  
  
  
  
  # Export.
  SuiteButton
  

        