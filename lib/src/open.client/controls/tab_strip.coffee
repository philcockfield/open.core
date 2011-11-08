core      = require '../core'
Button    = require './button'
ButtonSet = require './button_set'
mvc       = core.mvc

SELECTION_CHANGED = 'selectionChanged'

###
A horizontal strip of tabs.

Events:
 - selectionChanged

###
module.exports = class TabStrip extends mvc.View
  constructor: () -> 
      
      # Setup initial conditions.
      super tagName:'ul', className: @_className('tab_strip')
      @tabs = new ButtonSet()
      @el.disableTextSelect()
      
      # Wire up events.
      @tabs.bind SELECTION_CHANGED, (e) => @trigger SELECTION_CHANGED, tab:e.button
  
  
  # Determines the number of tabs within the strip (1-based).
  count: -> @tabs.length
  
  
  # Retrieves the first button in the set.
  first: -> @tabs.first()
  
  
  # Retrieves the last button in the set.
  last: -> @tabs.last()
  
  
  ###
  Clears the tab-strip and initializes it with the specified set of tabs.
  @param tabs - and array of tabs containing the [Tab] button definitions, for example:
            [
              { label:'One', value:1 }
              { label:'Two', value:2, enabled:false }
            ]
  @returns the collection of tabs.
  ###
  init: (tabs = []) ->
      
      # Setup initial conditions.
      @clear()
      
      # Add each tab.
      tabs = [tabs] unless _(tabs).isArray()
      @add tab for tab in tabs
      
      # Finish up.
      @
  
  
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
      @_cssPrefix = tabStrip._cssPrefix
      super _.extend options, tagName:'li', className: @_className('tab'), canToggle:true
      @tabStrip = tabStrip
      tabs      = tabStrip.tabs
      @render()
      
      # Attach the content element.
      @elContent = @$ '<div>'
      
      # Wire up events.
      @bind 'change',               => @updateState()
      @enabled.onChanged            => @selected false if not @enabled()
      tabs.bind 'add',              => @syncClasses()
      tabs.bind 'remove',           => @syncClasses()
      tabs.bind 'selectionChanged', => @updateState()
      
      # Finish up.
      @updateState()
  
  
  isFirst: -> @tabStrip.tabs.first() is @
  
  
  render: -> 
      prefix = @_cssPrefix
      @html new Tmpl().tab prefix:prefix
      @divLabel  = @$ "p.#{prefix}_label"
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
      @elContent?.toggle @selected()
      @syncClasses()
  
  
  syncClasses: -> 
      toggle = (className, apply) => @el.toggleClass @_className(className), apply
      toggle 'first', @isFirst()
      toggle 'before_selected', (@tabStrip.tabs.next(@)?.selected() is true)


class Tmpl extends mvc.Template
  tab: 
    """
    <div class="<%= prefix %>_div_left"></div>
    <p class="<%= prefix %>_label"></p>
    <div class="<%= prefix %>_div_right"></div>
    """



