require './_string'  # Cause string extensions to be loaded (added to underscore.string).


module.exports = util =
  Property: require './property'
  jQuery:   require './_jquery'   # NB: Also causees jQuery extensions to be loaded.
  
  
  ###
  Executes a [require] call within a try/catch block.
  @param path : Path to the require statement.
  @param options
            - throw: Flag indicating if the errors should be thrown (default: false)
            - log:   Flag indicating if errors should be written to the console (default: false)
  ###
  tryRequire: (path, options = {}) -> 
    throwOnError = options.throw ?= false
    log = options.log ?= false
    try
        window.require path
    catch error
        throw error if throwOnError
        console?.log '[tryRequire] Failed to load module: ' + path if log
  
  
  ###
  Updates the scroll CSS classes on the given element.
  @param el :  The jQuery element to update.
  @param axis: The axis to scroll on.
                - x:    scrolls horizontally only (class: core_scroll_x).
                - y:    scrolls vertically only (class: core_scroll_y). Default
                - xy:   scrolls both horizontally and vertically (class: core_scroll_xy).
                - null: no scrolling (class: core_scroll_none).
  @param options
                - prefix: The CSS prefix to apply. Default: 'core_scroll_'
  ###
  syncScroll: (el, axis, options = {}) -> 
      
      # Setup initial conditions.
      return el unless el?
      axis = 'y' if axis is undefined
      axis = _(axis).trim() if axis?
      prefix = options.prefix ? 'core_scroll_'
      
      toggle = (key, value) -> 
          value = key if value is undefined
          el.toggleClass prefix + key, value is axis
      toggle 'x'
      toggle 'y'
      toggle 'xy'
      toggle 'none', null
      
      # Finish up.
      el


# Extend with partial modules.
_.extend util, require './_conversion'
