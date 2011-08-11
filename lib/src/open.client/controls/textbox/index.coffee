core      = require 'open.client/core'
Template  = require './tmpl'

###
A general purpose textbox.
###
module.exports = class Textbox extends core.mvc.View
  defaults: 
    text:       ''      # Gets or sets the content of the textbox.
    multiline:  false   # Gets whether the textbox supports multi-line input.
  
  constructor: (params = {}) -> 
      super tagName: 'span', className: 'core_textbox'
      @render()
      
  render: -> 
      # Base HTML.
      tmpl = new Template()
      html = tmpl.root()
      @html html
      
      # Reference elements
      
      # Finish up.
      @