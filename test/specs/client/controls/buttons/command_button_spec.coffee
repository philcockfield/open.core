describe 'controls/buttons/command_button', ->
  CommandButton = null
  button = null
  beforeEach ->
      CommandButton = controls.CommandButton
      button = new CommandButton()
  
  it 'exists', ->
    expect(CommandButton).toBeDefined()
    
  it 'dervies from [Button]', ->
    expect(button instanceof controls.Button).toEqual true 
  
  it 'is a <button> element', ->
    expect(button.el.get(0).tagName).toEqual 'BUTTON'
  
  describe 'CSS classes', ->
    it 'has default classes', ->
      expect(button.el.get(0).className).toEqual 'core_cmd core_size_m'
    
    describe 'selected state - [active] class', ->
      beforeEach ->
          button = new CommandButton canToggle:true

      it 'does not have [active] class when not selected', ->
        expect(button.el.hasClass 'active').toEqual false
      
      it 'has [active] class when selected', ->
        button.selected true
        expect(button.el.hasClass 'active').toEqual true

      it 'removes [active] class when de-selected', ->
        button.selected true
        button.selected false
        expect(button.el.hasClass 'active').toEqual false

      it 'has [active] class when selected is set in constructor', ->
        button = new CommandButton canToggle:true, selected:true
        expect(button.el.hasClass 'active').toEqual true
  
  describe 'size', ->
    it 'is a medium (m) sized button by default', ->
      expect(button.size()).toEqual 'm'
    
    it 'changes the size to large (l)', ->
      button.size 'l'
      expect(button.size()).toEqual 'l'
      expect(button.el.hasClass('core_size_l')).toEqual true
      expect(button.el.hasClass('core_size_m')).toEqual false
    # 
    it 'sets size from constructor parameter', ->
      button = new CommandButton size:'l'
      expect(button.size()).toEqual 'l'
      expect(button.el.hasClass('core_size_l')).toEqual true
    
    
  