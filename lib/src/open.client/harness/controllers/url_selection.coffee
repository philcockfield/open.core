module.exports = (module) ->
  Suite = module.models.Suite
  
  class UrlSelectionController
    constructor: () -> 
      
      # Wire up events.
      module.selectedSuite.onChanged (e) => @syncUrl()
      $(window).bind 'hashchange', => @load() unless @ignoreHashChanged
      
      # Finish up.
      @load()
    
    
    # Updates the URL hash to match the currently selected hash.
    syncUrl: () -> 
        id = module.selectedSuite()?.id ? ''
        @ignoreHashChanged    = true
        window.location.hash  = id
        @ignoreHashChanged    = false
    
    
    # Loads the previously selected suite from the URL.
    load: -> 
        
        # Get the ID of the suite to load from the URL.
        id = window.location.hash
        return if _(id).isBlank()
        id = _(id).strRight('#').toLowerCase()
        
        # Find the corresponding suite.
        match = Suite.all.find (s) -> s.id.toLowerCase() is id
        unless match?
            # No matching suite exists anymore.
            # Clear it from the URL.
            window.location.hash = ''
            module.selectedSuite null
            return
        
        # Select the suite.
        # NB: This is done asynchronously (using the timer) to allow the
        #     TestHarness view(s) to be inserted and finish rendering
        #     before selection animcatino starts.
        setTimeout (-> module.selectedSuite match), 100    




        