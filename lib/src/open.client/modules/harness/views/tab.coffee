module.exports = (module) ->
  class TabBase extends module.mvc.View
    constructor: (props = {}) -> 
        super _.extend props, className:'th_tab'
          
        @html 'tab'
        