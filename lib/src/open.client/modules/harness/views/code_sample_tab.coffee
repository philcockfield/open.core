module.exports = (module) ->
  class CodeSampleTab extends module.mvc.View
    constructor: (props = {}) -> 
        super _.extend props, className:'th_tab th_code_sample'
          
        @html 'code sample'
        