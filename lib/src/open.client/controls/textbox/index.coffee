core      = require 'open.client/core'
Template  = require './tmpl'

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
      
      # Finish up.
      @