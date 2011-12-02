module.exports = (module) ->
  SpecButton = module.view 'spec_button'
  
  class SpecList extends module.mvc.View
    constructor: () -> 
        # Setup initial conditions.
        super className: 'th_spec_list'
        @buttons = new module.controls.ButtonSet()
        @render()
        
        # Wire up events.
        module.selectedSuite.onChanged (e) => @renderList()
    
    
    # Gets the pixel height of the contained list.
    listHeight: -> 
        ul = @ul
        cssNum = module.core.util.jQuery.cssNum
        ul.height() + cssNum(ul, 'margin-top') + cssNum(ul, 'margin-bottom')
    
    
    # Gets the pixel height of the list and it's title bar.
    offsetHeight: -> 
        titleHeight = @divTitleBar.height() + 2 # Account for border.
        titleHeight + @listHeight()
    
    
    render: -> 
        @html module.tmpl.specList()
        @ul          = @$ 'ul'
        @divTitleBar = @$ '.th_title_bar'
        @divTitleBar.disableTextSelect()
        @renderList()
    
    
    renderList: () -> 
        
        # Setup initial conditions.
        suite = module.selectedSuite()
        return unless suite?
        
        # Clear the UL.
        ul = @ul
        ul.empty()
        
        # Enumerate each spec.
        suite.specs.each (spec) => 
            
            # Create the button and insert it into the list.
            btn = new SpecButton model:spec
            @buttons.add btn
            
            # Append it to the UL within a LI.
            li = $('<li class="th_btn">')
            li.append btn.el
            ul.append li
