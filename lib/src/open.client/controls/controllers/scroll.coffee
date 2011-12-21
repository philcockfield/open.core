core      = require 'open.client/core'


###
Extends a view to make it scrollable.
###
module.exports = class ScrollController
  constructor: (view) -> 
    
    # Add the scroll property.
    unless view.scroll?.onChanged?
     view.addProps
       scroll: null # Gets or sets the scroll behavior of the content (values: null, 'x', 'y' or 'xy').
    
    # Sycers.
    sync = -> core.util.syncScroll view.el, view.scroll()
    
    # Wire up events.
    # - Handler: Validate property.
    view.scroll.onChanging (e) -> 
      value  = e.newValue
      value  = value?.toLowerCase()
      throw "'#{value}' not valid scroll value (x,y or xy)" if not isValid value
      e.newValue = value
    
    # - Handler: Sync state on scroll changed.
    view.scroll.onChanged sync
    
    # Finish up.
    sync()


# PRIVATE --------------------------------------------------------------------------


isValid = (value) -> return true if value is valid for valid in ['x', 'y', 'xy']

