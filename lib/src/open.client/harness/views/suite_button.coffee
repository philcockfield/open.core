module.exports = (module) ->
  Button = module.controls.Button
  
  class SuiteButton extends Button
    constructor: (options = {}) -> 
        
        # Setup initial conditions.
        super _.extend options, tagName: 'li', className: 'th_btn th_suite th_root', canToggle:true
        @model = options.model
        @childSuiteButtons = new module.controls.ButtonSet()
        @model.init()
        
        # Render the button.
        @render()
        @el.disableTextSelect()
        
        # Wire up events.
        # EVENT: child-suite button selection changed.
        @childSuiteButtons.bind 'selectionChanged', => 
                # Update the currently selected suite on the root module.
                return unless @selected
                btn = @childSuiteButtons.selected()
                module.selectedSuite btn?.model
        
        # EVENT: Selected 'suite' changed on root module.
        module.selectedSuite.onChanged (e) => 
                # Ensure the button is selected if the model is set as the selected suite.
                rootSuite = e.newValue?.root()
                @selected(true) if rootSuite is @model
        
        # Finish up.
        @_updateState()
    
    render: -> 
        # Render base HTML.
        @html module.tmpl.suiteButton()
        
        childButton = (suite) => 
                        btn = new SubSuiteButton model:suite
                        @childSuiteButtons.add btn
                        btn
        
        # Insert the root suite title as a button.
        @rootButton = childButton(@model).replace @$('.th_title')
        
        # Render any child-suites that may exist.
        renderChildSuites = (elParent, model) ->
            return if model.childSuites.length is 0
            
            # Insert the containing UL.
            ul = $('<ul class="th_sub_suites"></ul>')
            elParent.append ul
            
            # Enumerate each child spec.
            model.childSuites.each (suite) ->
                      
                      # Create the sub-suite button.
                      btn = childButton suite
                      
                      # Insert the LI.
                      title = _(suite.title()).capitalize()
                      li    = $("<li class='th_suite th_child'></li>")
                      li.append btn.el
                      # li.html $("<p>#{title}</p>")
                      
                      # Insert child suites in a new child UL.
                      suite.init()
                      renderChildSuites li, suite # <== Recursion.
                      
                      # Insert the LI into the UL
                      ul.append li
        renderChildSuites @el, @model
        
        # Finish up.
        @ulChildSuites = @el.children('ul.th_sub_suites')
    
    
    handleSelectedChanged: -> @_updateState true
    
    
    _updateState: (animate = false) -> 
          
          # Setup initial conditions.
          isSelected = @selected()
          @_updateSubButtons()
          
          # Show or hide the list of child-suites.
          aniToggle = (el, show, duration = 100) -> if show then el.show(duration) else el.hide(duration)
          do => 
              ul       = @ulChildSuites
              isHidden = ul.is(':hidden')
              show     = (isSelected and @model.childSuites.length > 0) and isHidden
              if animate then aniToggle(ul, show) else ul.toggle show
    
    
    _updateSubButtons: -> 
          buttons = @childSuiteButtons
          
          # Select or unselect the sub-suite button.
          if @selected()
            
            # Select first button - unless a selection already exists.
            buttons.items.first().selected true unless buttons.selected()?
            
          else
            buttons.selected()?.selected false
  
  
  class SubSuiteButton extends Button
    constructor: (options = {}) -> 
        super _.extend options, className: 'th_btn th_suite', canToggle:true
        @model = options.model
        @render()
        
        # EVENT: Selected 'suite' changed on root module.
        module.selectedSuite.onChanged (e) => 
                # Ensure the button is selected if the model is set as the selected suite.
                @selected(true) if e.newValue is @model
    
    
    render: -> 
        title = _(@model.title()).capitalize()
        @html title
  
  
  
  # Export.
  SuiteButton
  

        