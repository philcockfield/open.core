core           = require 'open.client/core'
SizeController = require '../controllers/size'


###
A popup container with an anchor arrow that points at
the origin controls the popup is extending.
###
module.exports = class Popup extends core.mvc.View
  defaults:
    width:        null
    height:       null
    controller:   null # Gets or sets the [PopupController] that is controlling this view.
    
    anchor: 'nw'  # Gets or sets the edge that the anchor pointer is on.
                  # Values are abbreviations of north, south, east, west cardinals.
                  # 
                  # The order of double cardinals (eg. 'ne') determines the pimary edge.
                  #   The first value determines the primary edge the anchor is on.
                  #   The second value determines the which vertical or horizontal edge it's closest to.
                  # 
                  # Permutations:
                  # 
                  #  - n:   top     horizontal-center
                  #  - s:   bottom  horizontal-center
                  #  - w:   left    vertical-center
                  #  - e:   right   vertical-center
                  #  
                  #  - ne:  top left
                  #  - nw:  top right
                  #  - wn:  left top
                  #  - en:  right top
                  #  
                  #  etc.
    
    
  constructor: (props = {}) -> 
    # Setup initial conditions.
    super _.extend props, className: @_className 'popup'
    @html new Tmpl().root(prefix:@_cssPrefix)
    
    # Create controllers.
    new SizeController @
    
    wirePopupController = (oldController, newController) =>  
      old.unbind 'updated' if oldController?
      if newController?
        newController.bind 'updated', (e) => 
          
          console.log 'newController.offset', newController.offset
          
          switch e.edge
            when 'n' then @anchor 'sw'
            when 's' then @anchor 'nw'
            when 'w' then @anchor 'en'
            when 'e' then @anchor 'wn'
    
    # Wire up events.
    @anchor.onChanging (e) -> 
        # Ensure the anchor exists and that it is lower case.
        value = e.newValue
        value = 'nw' if value is null or _(value).isBlank()
        e.newValue = value.toLowerCase()
    @anchor.onChanged => syncAnchor @
    @controller.onChanged (e) => wirePopupController e.oldValue, e.newValue
    
    # Finish up.
    syncAnchor @
    wirePopupController null, @controller()


# PRIVATE --------------------------------------------------------------------------


CARDINALS = 'n s w e'.split(' ')


syncAnchor = (view) -> 
  anchor  = view.anchor()
  elEdge  = null
  edge    = null
  
  # Update the visibility of the primary edge.
  setEdgeVisibility = (cardinal) -> 
    isVisible = _(anchor).startsWith cardinal
    el        = view.$ '.' + view._className(cardinal)
    el.toggle isVisible
    if isVisible
      elEdge = el
      edge   = cardinal
  setEdgeVisibility cardinal for cardinal in CARDINALS
  
  # Update the position of the anchor within the visible edge.
  edgePosition = (edges) -> 
    for key of edges
      return edges[key] if key is anchor[1]
    'center'
  
  switch edge
    when 'n', 's'
      x = edgePosition w:'left', e:'right'
      elEdge.css 'background-position', "#{x} top"
    when 'w', 'e'
      y = edgePosition n:'top', s:'bottom'
      elEdge.css 'background-position', "left #{y}"





class Tmpl extends core.mvc.Template
  root:
    """
    <div class="<%= prefix %>_inner"></div>    
      
    <div class="<%= prefix %>_w"></div>
    <div class="<%= prefix %>_e"></div>
    <div class="<%= prefix %>_n"></div>
    <div class="<%= prefix %>_s"></div>
    """




