Button = require './button'

###
A button that presents an icon and optionally a text label.
###
module.exports = class Icon extends Button
  constructor: (props = {}) -> 
    super _.extend props, tagName:'span', className:@_className 'icon'
    @render()
  
  
  render: -> 
    @html 'Icon Button'
  
  


