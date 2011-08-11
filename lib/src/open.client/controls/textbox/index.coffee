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
  
  constructor: (params = {}) -> 
      # Setup initial conditions.
      super _.extend params, tagName: 'span', className: 'core_textbox'
      @render()
      
      # Wire up events.
      @multiline.onChanged => @render()
      @password.onChanged => @render()
      
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
  focus: -> 
    console.log '@_input', @_input
    @_input.focus()
      