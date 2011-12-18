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
          - handleOverflow:   Flag indicating if the edge of the Popup should be inverted if
                              if the popup would overflow the bounds of the page.
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
    
    core.bind 'window:resize', => @update()
  
  
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
    # Determine the X:Y plane for the popup.
    
    
    willOverflow = (onPlane, relativeToEdge, value) -> 
      switch onPlane
        when 'x' 
          screenWidth = $(window).width()
          
          # TODO 
        
        when 'y' 
          switch relativeToEdge
            when 'n'
              return false if value > 0
            when 's' 
              bottom       = value + elPopup.height()
              screenHeight = $(window).height()
              return false if bottom < screenHeight
          
      # Finish up.
      true
          
    
    getTop = => 
      
      topForVerticalEdge = (edge) -> 
        switch edge
          when 'n' then return contextPosition.top - elPopup.height() - offset.y
          when 's' then return contextPosition.top + elContext.height() + offset.y
      
      topForHorizontalEdge = (edge) -> 
        switch edge
          when 'n' then return contextPosition.top + offset.y
          when 's' then return (contextPosition.top + elContext.height()) - elPopup.height() - offset.y
      
      switch plane
        when 'x'  
          top = topForHorizontalEdge 'n'
          
          if willOverflow 'y', 's', top
            oppositeTop = topForHorizontalEdge 's'
            unless willOverflow 'y', 'n', oppositeTop
              top = oppositeTop
        
        
        
        when 'y' 
          top = topForVerticalEdge @edge
        
          if willOverflow 'y', @edge, top
            oppositeEdge  = toOppositeEdge @edge
            oppositeTop   = topForVerticalEdge oppositeEdge
            unless willOverflow 'y', oppositeEdge, oppositeTop
              top = oppositeTop
          
      # Finish up.
      top
    
    
    
    top = getTop()
    
    console.log 'top', top
    
    left = contextPosition.left # TEMP 
    
    
    # Update the popup position.
    elPopup.css 'top',  top
    elPopup.css 'left', left
    
    

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







  