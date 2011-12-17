describe 'controls/views/icon', ->
  Icon = null
  icon = null
  
  beforeEach ->
    Icon = controls.Icon
    icon = new Icon()
  
  it 'exists', ->
    expect(Icon).toBeDefined()
  
  it 'is a [Button]', ->
    expect(icon instanceof controls.Button).toEqual true 
  
  
  