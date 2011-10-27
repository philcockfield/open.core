core      = require '../core'
Button    = require './button'
ButtonSet = require './button_set'
mvc       = core.mvc


###
A horizontal strip of tabs.
###
module.exports = class TabStrip extends mvc.View
  constructor: () -> 
      super tagName:'ul', className: @_className('tab_strip')
      @tabs = new ButtonSet()
      @el.disableTextSelect()
  
  
  # Determines the number of tabs within the strip (1-based).
  count: -> @tabs.length
  
  
  # Retrieves the first button in the set.
  first: -> @tabs.first()
  
  
  # Retrieves the last button in the set.
  last: -> @tabs.last()
  
  
  ###
  Adds a new [Tab] button to the strip.
  @param options : The options to apply when creating the new [Tab] button.
  @returns the new [Tab] button.
  ###
  add: (options = {}) -> 
      
      # Create the tab and store it in the set.
      tab = @tabs.add new Tab(@, options)
      
      # Insert the element within the DOM.
      @el.append tab.el
      
      # Finish up.
      tab
  
  
  ###
  Removes the given tab from the strip.
  @param tab: The tab button to remove.
  ###
  remove: (tab) -> tab.remove() if tab?
  
  
  # Removes all tabs from the strip.
  clear: -> 
      # NB: Make a clone of the collection because it is being removed from.
      clonedTabs = @tabs.items.map (t) -> t
      tab.remove() for tab in clonedTabs


###
An individual Tab button.

Events:
  - removed
###
TabStrip.Tab = class Tab extends Button
  constructor: (tabStrip, options = {}) ->
      
      # Setup initial conditions.
      super _.extend options, tagName:'li', className: @_className('tab'), canToggle:true
      @tabStrip = tabStrip
      tabs      = tabStrip.tabs
      @render()
      
      # Wire up events.
      @bind 'change',               => @updateState()
      @enabled.onChanged            => @selected false if not @enabled()
      tabs.bind 'add',              => @syncClasses()
      tabs.bind 'remove',           => @syncClasses()
      tabs.bind 'selectionChanged', => @syncClasses()
  
  
  isFirst: -> @tabStrip.tabs.first() is @
  
  
  render: -> 
      @html new Tmpl().tab()
      @divLabel = @$ 'p.core_label'
      @updateState()
      @syncClasses()
  
  
  remove: -> 
      
      # Remove from DOM and the strip's collection.
      @el.remove()
      @tabStrip.tabs.remove @
      
      # Alert listeners.
      @trigger 'removed', 
          tab:@
          tabStrip:@tabStrip
      
      
  
  updateState: -> 
      @divLabel.html @label()
  
  
  syncClasses: -> 
      toggle = (className, apply) => @el.toggleClass @_className(className), apply
      toggle 'first', @isFirst()
      toggle 'before_selected', (@tabStrip.tabs.next(@)?.selected() is true)


class Tmpl extends mvc.Template
  tab: 
    """
    <div class="core_div_left"></div>
    <p class="core_label"></p>
    <div class="core_div_right"></div>
    """



