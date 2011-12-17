core = require 'open.client/core'

###
A popup container with an anchor arrow that points at
the origin controls the popup is extending.
###
module.exports = class Popup extends core.mvc.View
  constructor: (props = {}) -> 
    super _.extend props, className: @_className 'popup'
    @render()
  
  render: -> 
    @html new Tmpl().root(prefix:@_cssPrefix)


class Tmpl extends core.mvc.Template
  root:
    """
    <div class="<%= prefix %>_inner"></div>    
      
    <div class="<%= prefix %>_w"></div>
    <div class="<%= prefix %>_e"></div>
    <div class="<%= prefix %>_n"></div>
    <div class="<%= prefix %>_s"></div>
    """




