module.exports = (module) ->
  class SelectionController
    constructor: () -> 
      
      # Wire up events.
      module.selectedSuite.onChanged (e) => 
            @syncUrl()
            @save()
    
    
    # Updates the URL hash to match the currently selected hash.
    syncUrl: () -> 
        
        # Setup initial conditions.
        suite = @toIdentifier()
        
        # Generate the URL.
        if suite.exists
            suite.encode()
            url = suite.root
            url += "//#{suite.selected}" unless suite.isRoot()
        else
            url = ''
        
        # Update the URL hash.
        window.location.hash = url
    
    
    # Extracts the uniqude identifying parts of the currently selected suite.
    toIdentifier: () -> 
        suite = module.selectedSuite()
        identifier =
            exists:   suite?
            root:     suite?.root().title() ? null
            selected: suite?.title() ? null
            isRoot: -> @root is @selected
            encode: -> 
                return unless @exists
                
                # @root = @root.replace /\//g, '\\'
                
                @root     = encodeURI(@root)
                @selected = encodeURI(@selected)
    
    
    # Saves the selected suite to storage.
    save: () -> 
        local = localStorage
        return unless local?
        suite               = @toIdentifier()
        local.selectedRoot  = suite.root
        local.selectedSuite = suite.selected
    
    






        