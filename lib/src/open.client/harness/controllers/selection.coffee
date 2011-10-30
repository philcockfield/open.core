module.exports = (module) ->
  class SelectionController
    constructor: () -> 
      
      # Wire up events.
      module.selectedSuite.onChanged (e) => @save()
    
    
    setUrl: () -> 
        
        suite = @toIdentifier()
        
        
    
    # Saves the selected suite to storage.
    save: () -> 
        local = localStorage
        return unless local?
        suite               = @toIdentifier()
        local.selectedRoot  = suite.root
        local.selectedSuite = suite.selected
    
    # Extracts
    toIdentifier: () -> 
        suite = module.selectedSuite()
        identifier =
          root:     suite?.root().title() ? null
          selected: suite?.title() ? null
        
        
    

        