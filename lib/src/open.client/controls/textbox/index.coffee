core      = require 'open.client/core'
Template  = require './tmpl'

###
A general purpose textbox.
###
module.exports = class Textbox extends core.mvc.View
  constructor: (params = {}) -> 
      super className: 'core_textbox'
      @render()
      
  render: -> 
      tmpl = new Template()
      html = tmpl.root()
      @html html