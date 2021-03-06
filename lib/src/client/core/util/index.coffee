require './_string'               # Cause string extensions to be loaded (added to underscore.string).
jQueryUtil = require './_jquery'  # Cause jQuery extensions to be loaded.


module.exports = util =
  jQuery:   jQueryUtil
  toJQuery: jQueryUtil.toJQuery
  
  # Classes.
  Property: require './property'
  Cookie:   require './cookie'
  
  
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
      # NB: The global require is used if running on server (ie. [window] is not available).
      fnRequire = window?.require ? require
      fnRequire path
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
      axis = _(axis).trim().toLowerCase() if axis?
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
  
  
  ###
  Selects all <a> tags within the given element and
  assigns the [core_external] class to ones that start
  with an 'http://' or 'https://' or 'mailto:
  @param el: The element containing the <a> element to format.
  @param options
          - className: Optional. The class to assign to external links (default: 'core_').
          - tooltip:   Optional. The tooltip text to assign (default: none).
          - target:    Optional. The target for the external link (default: '_blank').
          
  ###
  formatLinks: (el, options = {}) -> 
      # Setup initial conditions.
      return unless el?
      className = options.className ? 'core_external'
      tooltip   = options.tooltip 
      target    = options.target ? '_blank'
      
      getHref = (a) -> 
          href = a.attr 'href'
          href = _(href.toLowerCase()) if href?
          href
      
      isExternal = (href, a) -> 
          return false unless href?
          
          # Check for external domains.
          for prefix in ['http://', 'https://', 'mailto:']
            return true if href.startsWith(prefix)
          
          # Check for links opening in another tab/window.
          return true if a.attr('target') is target
          
          # Not external.
          false
      
      targetNewWindow = (href) -> 
          return false if href.startsWith('mailto:')
          return true
      
      # Process each anchor.
      process = (a) -> 
          href = getHref a
          return unless isExternal(href, a)
          
          # Update the CSS class.
          a.addClass className
          
          # Update the [target] attribute.
          a.attr 'target', target if target? and targetNewWindow(href)
          
          # Add tooltip.
          a.attr 'title', tooltip if tooltip?
      
      process $(a) for a in el.find('a')


# Extend with partial modules.
_.extend util, require './_conversion'



