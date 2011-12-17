describe 'controls/views/popup', ->
  Popup = null
  popup = null
  
  beforeEach ->
    Popup = controls.Popup
    popup = new Popup()
  
  
  it 'exists', ->
    expect(Popup).toBeDefined()
  
  it 'has an [anchor] property', ->
    expect(popup.anchor instanceof Function).toEqual true 
  
  it 'ensures the [anchor] property is lower case', ->
    popup.anchor 'Ne'
    expect(popup.anchor()).toEqual 'ne'
  
  it 'reset to the default [anchor]', ->
    popup.anchor ''
    expect(popup.anchor()).toEqual 'nw'
    
    popup.anchor '   '
    expect(popup.anchor()).toEqual 'nw'
    
    popup.anchor null
    expect(popup.anchor()).toEqual 'nw'
  
  
