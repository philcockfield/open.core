core   = require 'open.client/core'
util   = core.util
Button = null

MAX = 2147483647


###
Manages displaying a popup view over a context object.
###
module.exports = class PopupController
  ###
  Constructor.
  @param context:   The [View], [Button], or jQuery element, that represents is the 
                    source context for the popup.
  @param fnPopup:   Function that produces the [View] or jQuery that is the Popup
                    to be displayed as the popup when the context is clicked.
  @param options:
          - cssPrefix:        The CSS prefix to use (default 'core_').
          - clickable:        Flag indicating if the popup should be displayed when
                              the [content] is clicked (default true).
          - edge:             The cardinal representing the edge to snap the popup relative to.
                              Values:  'n', 's', 'w', 'e'
                              Default: 's'.
          - offset:           x:y pixel offset to nudge the popup away from the context by.
                              Positive values are interpretted as pushin away (out) from the context
                              irrespective of what 'edge' the popup is snapping to.
  ###
  constructor: (@context, @fnPopup, options = {}) -> 
    
    # Setup initial conditions.
    Button ?= require '../views/button' # NB: Required here so that the proper singleton instance is used.
    
    toJQuery  = core.util.toJQuery
    context   = @context
    popup     = @popup
    
    options.cssPrefix       ?= 'core_'
    options.clickable       ?= true
    options.edge            ?= 's'
    options.offset          ?= { x:0, y:0 }
    options.handleOverflow  ?= true
    _.extend @, options
    
    # Extract jQuery elements.
    @elContext = elContext = toJQuery context
    
    # Wire up events.
    if options.clickable is yes
      if (context instanceof Button)
        context.onClick => @show()
      else
        elContext.click => 
          return if context.enabled? and context.enabled() is no
          @show() 
    
    $(window).resize => @update()
    
    # core.bind 'window:resize', => @update()
  
  
  ###
  Gets whether the popup is currently visble.
  ###
  isShowing: -> @elPopup?
  
  
  ###
  Reveals the popup.
  ###
  show: -> 
    
    # Setup initial conditions.
    return if @isShowing()
    body = $ 'body'
    
    # Get and display the screen mask.
    @elMask = do => 
      
      # Create and insert the mask.
      elMask = $ "<div class='#{@cssPrefix}popup_mask'></div>"
      body.append elMask
      
      # Wire up events.
      elMask.click => @hide()
      
      # Finish up.
      elMask
    
    # Create and insert the popup.
    popup   = @fnPopup()
    elPopup = core.util.toJQuery popup
    elPopup.css 'z-index', MAX
    elPopup.css 'position', 'absolute'
    body.append elPopup
    
    # Finish up.
    @elPopup = elPopup
    @update()
  
  
  ###
  Hides the popup.
  ###
  hide: -> 
    
    #  Remove the popup.
    @elPopup?.remove()
    delete @elPopup
    
    # Hide the screen mask.
    @elMask?.remove()
  
  
  ###
  Updates the visual state of the elements.
  ###
  update: -> 
    # Setup initial conditions.
    return unless @isShowing()
    elPopup         = @elPopup
    elContext       = @elContext
    offset          = @offset
    contextPosition = elContext.offset()
    plane           = toPlane @edge
    
    willOverflowVertically    = (relativeToEdge, value) -> willOverflow 'y', relativeToEdge, value
    willOverflowHorizontally  = (relativeToEdge, value) -> willOverflow 'x', relativeToEdge, value
    willOverflow = (onPlane, relativeToEdge, value) -> 
      switch onPlane
        when 'x' 
          switch relativeToEdge
            when 'w'
              return false if value > 0
            when 'e'
              right       = value + elPopup.width()
              screenWidth = $(window).width()
              return false if right < screenWidth
        
        when 'y' 
          switch relativeToEdge
            when 'n'
              return false if value > 0
            when 's' 
              bottom       = value + elPopup.height()
              screenHeight = $(window).height()
              return false if bottom < screenHeight
          
      return true # Will overfow.
    
    getTop = => 
      forHorizontalPlaneEdge = (edge) -> 
        switch edge
          when 'n' then return contextPosition.top + offset.y
          when 's' then return (contextPosition.top + elContext.height()) - elPopup.height() - offset.y
      
      forVerticalPlaneEdge = (edge) -> 
        switch edge
          when 'n' then return contextPosition.top - elPopup.height() - offset.y
          when 's' then return contextPosition.top + elContext.height() + offset.y
      
      switch plane
        when 'x'
          # Snapping to West or East edge.
          top = forHorizontalPlaneEdge 'n'
          if willOverflowVertically 's', top
            top = forHorizontalPlaneEdge 's'
        
        when 'y'
          # Snapping to North or South edge.
          top = forVerticalPlaneEdge @edge
          if willOverflowVertically @edge, top
            top = forVerticalPlaneEdge toOppositeEdge(@edge)
          
      return top
    
    
    getLeft = => 
      forHorizontalPlaneEdge = (edge) -> 
        switch edge
          when 'w' then return contextPosition.left - elPopup.width() - offset.x
          when 'e' then return contextPosition.left + elContext.width() + offset.x
      
      forVerticalPlaneEdge = (edge) -> 
        switch edge
          when 'w' then return contextPosition.left + offset.x
          when 'e' then return (contextPosition.left + elContext.width()) - elPopup.width() - offset.y
      
      switch plane
        when 'x'
          # Snapping to East or West edge.
          left = forHorizontalPlaneEdge @edge
          if willOverflowHorizontally @edge, left
            left = forHorizontalPlaneEdge toOppositeEdge(@edge)
          
        when 'y'
          # Snapping to North or South edge.
          left = forVerticalPlaneEdge 'w'
          if willOverflowHorizontally 'e', left
            left = forVerticalPlaneEdge 'e'
      
      return left
    
    
    # Update the popup position.
    elPopup.css 'left', getLeft()
    elPopup.css 'top',  getTop()


# PRIVATE --------------------------------------------------------------------------


toOppositeEdge = (edge) ->
  switch edge
    when 'n' then return 's'
    when 's' then return 'n'
    when 'w' then return 'e'
    when 'e' then return 'w'


toPlane = (edge) -> 
  switch edge
    when 'n', 's' then return 'y'
    when 'w', 'e' then return 'x'







  