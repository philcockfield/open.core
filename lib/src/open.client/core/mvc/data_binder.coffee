common = require 'open.client/core/mvc/_common'
View   = common.using 'view'

module.exports = class DataBinder
  constructor: (model, view) -> 
      
      # Retrieve the element.
      if (view instanceof View) then @el = view.el
      else if (view instanceof jQuery) then @el = view
      else
        throw 'View type not supported'
      
      # Setup data-binding on elements.
      bind = (element) -> 
            prop = model[element.attr('data-bind')]
            sync = -> element.html prop()
            sync()
            prop.onChanged (e) -> sync()
            
      bind $(element) for element in @el.find('[data-bind]')

