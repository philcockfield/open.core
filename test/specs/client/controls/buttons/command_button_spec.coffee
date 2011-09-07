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
  
  it 'has CSS classes', ->
    expect(button.el.get(0).className).toEqual 'core_cmd core_size_m'
  
  describe 'size', ->
    it 'is a medium (m) sized button by default', ->
      expect(button.size()).toEqual 'm'
    
    it 'changes the size to large (l)', ->
      button.size 'l'
      expect(button.size()).toEqual 'l'
      expect(button.el.hasClass('core_size_l')).toEqual true
  
  
  