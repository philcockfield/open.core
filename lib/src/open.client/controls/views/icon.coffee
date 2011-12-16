core   = require 'open.client/core'
Button = require './button'


###
A button that presents an icon and optionally a text label.
###
module.exports = class Icon extends Button
  constructor: (props = {}) -> 
    
    # Setup initial conditions.
    super _.extend props, tagName:'span', className:@_className 'icon'
    @render()
    @el.disableTextSelect()
    
    # Syncers.
    syncLabel = => @_label.html @label()
    
    # Wire up events.
    @label.onChanged syncLabel
    
    # Finish up.
    syncLabel()
  
  
  render: -> 
    # Insert base HTML.
    @html new Tmpl().root(prefix:@_cssPrefix)
    
    # Retrieve element refs.
    el = (className) => @$ '.' + @_className(className)
    @_label = el 'label'
    @_icon  = el 'icon'
    @_carat = el 'carat'


# PRIVATE --------------------------------------------------------------------------


class Tmpl extends core.mvc.Template
  root:
    """
    <span class="<%= prefix %>_inner">
    </span>
    <p class="<%= prefix %>_label">Label</p>
    """
  
  foo:
    '''
    <div class='<%= prefix %>_icon'></div>


    <div class='<%= prefix %>_wrapper'>
      wrapper
    </div>


      <div class='<%= prefix %>_carat'></div>        
        
    '''
    






