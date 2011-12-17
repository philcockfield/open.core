core = require 'open.client/core'


module.exports = class Popup extends core.mvc.View
  constructor: (props = {}) -> 
    super _.extend props, className: @_className 'popup'
    @render()
      
  
  render: -> 
    @html 'Popup'