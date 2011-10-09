module.exports = (module) ->
  class DescriptionButton extends module.controls.Button
    constructor: (options = {}) -> 
        super _.extend options, tagName: 'li', className: 'th_desc_btn', canToggle:true
        @model = options.model
        @render()
        @el.disableTextSelect()
    
    render: -> 
      @html module.tmpl.descriptionButton(model: @model)
    
    
    handleSelectedChanged: -> # @render()
    
        