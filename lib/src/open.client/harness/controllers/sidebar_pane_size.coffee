module.exports = (module) ->
  class SidebarPaneSizeController
    constructor: (@sidebar) -> 
        # Wire up events.
        module.selectedSuite.onChanged    => @syncSize()
        module.core.bind 'window:resize', => @syncSize()
        
        # Finish up.
        @syncSize()
    
    
    syncSize: -> 
        # Setup initial conditions.
        suite      = module.selectedSuite()
        totalSpecs = suite?.specs.length ? 0
        sidebar    = @sidebar
        specList   = sidebar.specList
        suiteList  = sidebar.suiteList
        
        # Update visibility of the specs list.
        specList.visible totalSpecs > 0
        
        # Calculate heights.
        sidebarHeight = sidebar.el.height()
        specsHeight   = if totalSpecs is 0 then 0 else specList.offsetHeight()
        
        # Ensure the specs-height is not more than 50% of the container's height.
        half = sidebarHeight * 0.5
        specsHeight = half if specsHeight > half
        
        # Update heights of the controls.
        specsHeight += 'px'
        suiteList.el.css 'bottom', specsHeight
        specList.el.css 'height', specsHeight
        
        
        