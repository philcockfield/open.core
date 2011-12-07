core      = require '../core'


###
A general purpose textbox.

Events:
 - press:enter
 - press:escape

###
module.exports = class Textbox extends core.mvc.View
  defaults: 
    text:       ''      # Gets or sets the content of the textbox.
    multiline:  false   # Gets whether the textbox supports multi-line input.
    password:   false   # Gets or sets whether the textbox is a password (only valid if not multi-line).
    prompt:     ''      # Gets or sets the watermark prompt.
  
  constructor: (params = {}) -> 
      # Setup initial conditions.
      super _.extend params, tagName: 'span', className: @_className('textbox')
      @render()
      
      syncPrompt = => 
            @_.prompt.html (if @empty() then @prompt() else '')
      
      syncFocus = (hasFocus) => 
        hasFocus = @hasFocus() unless hasFocus?
        @el.toggleClass @_className('focused'), hasFocus
      
      # Wire up events.
      @multiline.onChanged => @render()
      @password.onChanged  => @render()
      @prompt.onChanged    syncPrompt
      @text.onChanged      syncPrompt
      @_.input.focusin => syncFocus(true)
      @_.input.focusout => syncFocus(false)
      
      # Key events.
      @_.input.keyup (e) => 
          @enterPress()  if e.keyCode is 13
          @escapePress() if e.keyCode is 27
      
      # Key handlers.
      _.extend @_, keyHandlers =
          press: (event) => @trigger 'press:' + event,  source: self 
          onPress: (event, callback) => @bind 'press:' + event, callback
      
      # Finish up.
      syncPrompt()
      syncFocus()
      
      
  render: -> 
      # Setup initial conditions.
      inputType = if @password() then 'password' else 'text'
      
      # Base HTML.
      tmpl = new Tmpl()
      html = tmpl.root( textbox:@, inputType: inputType, prefix:@_cssPrefix )
      @html html
      
      # Reference elements.
      elInput     = if @multiline() then @$('textarea') else @$('input')
      elPrompt    = @$ "span.#{@_className('prompt')}"
      
      # Finish up.
      @_.syncer    = new textSyncer(@.text, elInput)
      @_.input     = elInput
      @_.prompt    = elPrompt
      @
  
  
  # Applies focus to the INPUT element.
  focus: -> @_.input.focus()
  
  
  # Determines whether the textbox has the focus.
  hasFocus: -> @$('input:focus').length is 1
  
  
  ###
  Determines whether the textbox is empty.
  @param trim : Flag indicating if white space should be trimmed before 
                evaluating whether the textbox is empty (default true).
  ###
  empty: (trim = true) -> 
      text = @text()
      return true if not text?
      text = _.trim(text) if trim
      return true if text is ''
      return false
  
  
  ###
  Called when the [Enter] key is pressed.
  This can also be used to simulate the [Enter] key press event.
  ###
  enterPress: -> @_.press 'enter'
  
  
  ###
  Called when the [Escape] key is pressed.
  Note: This can also be used to simulate the [Escape] key press event.
  ###
  escapePress: -> @_.press 'escape'
  
  
  ###
  Wires an event handler to the [Enter] key-press.
  @param callback: to invoke when the [Enter] key is pressed.
  ###
  onEnter: (callback) -> @_.onPress 'enter', callback
  
  
  ###
  Wires an event handler to the [Escape] key-press.
  @param callback: to invoke when the [Escape] key is pressed.
  ###
  onEscape: (callback) -> @_.onPress 'escape', callback      


# PRIVATE --------------------------------------------------------------------------


textSyncer = (textProperty, input) -> 
      # Syncer.
      ignore = false
      sync = (fn) -> 
          ignore = true
          fn()
          ignore = false
    
      # Keep INPUT synchronized with [textbox.text] property.
      syncInput = -> 
            return if ignore
            sync -> input.val textProperty()
      syncInput() # Sync on load.
      textProperty.onChanged syncInput
    
      # Keep [textbox.text] property synchronized with INPUT.
      syncProperty = -> 
            return if ignore
            sync -> textProperty input.val()
      input.keyup syncProperty
      input.change syncProperty


class Tmpl extends core.mvc.Template
  root: 
    """
      <span class="<%= prefix %>_inner">
        &nbsp;
        <span class="<%= prefix %>_prompt"></span>
        <% if (textbox.multiline()) { %>
          <textarea></textarea>
        <% } else { %>
          <input type="<%= inputType %>" />
        <% } %>
      </span>
    """


