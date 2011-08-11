core      = require 'open.client/core'
Template  = require './tmpl'

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


###
A general purpose textbox.
###
module.exports = class Textbox extends core.mvc.View
  defaults: 
    text:       ''      # Gets or sets the content of the textbox.
    multiline:  false   # Gets whether the textbox supports multi-line input.
    password:   false   # Gets or sets whether the textbox is a password (only valid if not multi-line).
    watermark:  ''      # Gets or sets the watermark.
  
  constructor: (params = {}) -> 
      # Setup initial conditions.
      super _.extend params, tagName: 'span', className: 'core_textbox'
      @render()
      
      syncWatermark = () => 
            @$('span.core_watermark').html (if @empty() then @watermark() else '')
      
      # Wire up events.
      @multiline.onChanged => @render()
      @password.onChanged  => @render()
      @watermark.onChanged syncWatermark
      @text.onChanged      syncWatermark
      
      # Finish up.
      syncWatermark()
      
  render: -> 
      # Setup initial conditions.
      inputType = if @password() then 'password' else 'text'
      
      # Base HTML.
      tmpl = new Template()
      html = tmpl.root( textbox:@, inputType: inputType )
      @html html
      
      # Reference elements.
      input = if @multiline() then @$('textarea') else @$('input')
      
      # Finish up.
      @_syncer = new textSyncer(@.text, input)
      @_input = input
      @
      
  # Applies focus to the INPUT element.
  focus: -> @_input.focus()
  
  
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
      
      
      
      
      
      
      
      
      
      
      