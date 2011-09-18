describe 'controls/buttons/cmd_button', ->
  CmdButton = null
  button = null
  beforeEach ->
      CmdButton = controls.CmdButton
      button = new CmdButton()
  
  it 'exists', ->
    expect(CmdButton).toBeDefined()
    
  it 'dervies from [Button]', ->
    expect(button instanceof controls.Button).toEqual true 
  
  it 'is a SPAN element', ->
    expect(button.el.get(0).tagName).toEqual 'SPAN'
  
  describe 'CSS classes', ->
    it 'has default classes', ->
      expect(button.el.get(0).className).toEqual 'core_btn_cmd core_size_m core_color_silver'
    
    describe 'selected state - [active] class', ->
      beforeEach ->
          button = new CmdButton canToggle:true

      it 'does not have [active] class when not selected', ->
        expect(button._btn.hasClass 'active').toEqual false
      
      it 'has [active] class when selected', ->
        button.selected true
        expect(button._btn.hasClass 'active').toEqual true

      it 'removes [active] class when de-selected', ->
        button.selected true
        button.selected false
        expect(button._btn.hasClass 'active').toEqual false

      it 'has [active] class when selected is set in constructor', ->
        button = new CmdButton canToggle:true, selected:true
        expect(button._btn.hasClass 'active').toEqual true
  
  describe 'size', ->
    it 'is a medium (m) sized button by default', ->
      expect(button.size()).toEqual 'm'
      expect(button.el.hasClass('core_size_m')).toEqual true
    
    it 'changes the size and CSS class to large (l)', ->
      button.size 'l'
      expect(button.size()).toEqual 'l'
      expect(button.el.hasClass('core_size_l')).toEqual true
      expect(button.el.hasClass('core_size_m')).toEqual false

    it 'sets size from constructor parameter', ->
      button = new CmdButton size:'l'
      expect(button.size()).toEqual 'l'
      expect(button.el.hasClass('core_size_l')).toEqual true
    

  describe 'color', ->
    it 'is [silver] by default', ->
      expect(button.color()).toEqual 'silver'
      expect(button.el.hasClass('core_color_silver')).toEqual true

    it 'changes the color and CSS class to [blue]', ->
      button.color 'blue'
      expect(button.color()).toEqual 'blue'
      expect(button.el.hasClass('core_color_blue')).toEqual true
      expect(button.el.hasClass('core_color_silver')).toEqual false
    
    it 'sets color from constructor parameter', ->
      button = new CmdButton color: 'blue'
      expect(button.color()).toEqual 'blue'
      expect(button.el.hasClass('core_color_blue')).toEqual true

  describe 'text', ->
    beforeEach ->
      button = new CmdButton label:'foo'
    
    it 'sets the text on the BUTTON element upon construction', ->
      expect(button._btn.text()).toEqual 'foo'

    it 'changes the text in the BUTTON element', ->
      button.label 'bar'
      expect(button._btn.text()).toEqual 'bar'

      
    
    
    
      
      
    
    
    
    
    
    
    
    
    
    
    
    
    
  