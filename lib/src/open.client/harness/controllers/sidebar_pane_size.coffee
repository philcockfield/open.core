module.exports = (module) ->
  class SidebarPaneSizeController
    constructor: (@suiteList, @specList) -> 
        # Wire up events.
        module.selectedSuite.onChanged => @syncSize()
    
    
    syncSize: -> 
        # Setup initial conditions.
        specList = @specList
        
        height = specList.el.height()
        listHeight = specList.listHeight()
        
        # 
        # console.log 'listHeight', listHeight
        # console.log 'specList.listHeight()', specList.listHeight()
        
        
        
        
    
        
        