describe 'controls/controllers/focus', ->
  Focus = null
  focus = null
  view  = null
  
  beforeEach ->
    Focus = controls.controllers.Focus
    view = new core.mvc.View()
    focus = new Focus view, view.el
  
  it 'exists', ->
    expect(Focus).toBeDefined()
  
  
  it 'adds a [focus] method', ->
    expect(view.focus instanceof Function).toEqual true 
  
  
  describe 'CSS class updating', ->
    it 'adds the [focused] CSS class', ->
      expect(view.el.hasClass('core_focused')).toEqual false
      view.focus()
      expect(view.el.hasClass('core_focused')).toEqual true
  
    it 'removes the [focused] CSS class', ->
      view.focus()
      expect(view.el.hasClass('core_focused')).toEqual true
      view.el.blur()
      expect(view.el.hasClass('core_focused')).toEqual false
    
    it 'uses the custom CSS class prefix', ->
      view._cssPrefix = 'foo'
      view.focus()
      expect(view.el.hasClass('foo_focused')).toEqual true
      
    
    
    
  
  
  
  
  
    
  
  
  