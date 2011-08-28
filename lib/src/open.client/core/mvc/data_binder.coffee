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
            propName = element.attr('data-bind')
            prop = model[propName]
            prop.onChanged (e) -> element.html prop()
      bind $(element) for element in @el.find('[data-bind]')

