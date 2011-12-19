describe 'controls/views/icon_button', ->
  IconButton = null
  btn        = null
  
  beforeEach ->
    IconButton = controls.IconButton
    btn = new IconButton()
  
  it 'exists', ->
    expect(IconButton).toBeDefined()
  
  it 'is a [Button]', ->
    expect(btn instanceof controls.Button).toEqual true 
  
  
  