describe 'mvc/view', ->
  View = null
  beforeEach ->
    View = core.mvc.View

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled View, -> new View()

  it 'supports eventing', ->
    expect(-> new View().bind('foo')).not.toThrow()
  
  describe 'el', ->
    it 'has an el which is a jQuery object', ->
      view = new View()
      expect(view.html instanceof Function).toEqual true
  
  describe 'tagName', ->
    it 'is a DIV by default', ->
      view = new View()
      expect(view.el.get(0).tagName).toEqual 'DIV'
  
    it 'has a custom tag name', ->
      view = new View( tagName:'li' )
      expect(view.el.get(0).tagName).toEqual 'LI'
  
  describe 'classname', ->
    it 'has no class name by default', ->
      view = new View()
      expect(view.el.get(0).className).toEqual ''
  
    it 'has a custom class name', ->
      view = new View( className: 'foo bar' )
      expect(view.el.get(0).className).toEqual 'foo bar'
  
  
  describe 'html', ->
    it 'insert HTML within the view', ->
      view = new View()
      view.html '<p>foo</p>'
      expect(view.el.clone().wrap('<div></div>').parent().html()).toEqual '<div><p>foo</p></div>'
  
    it 'reads the views inner HTML', ->
      view = new View()
      view.html '<p>foo</p>'
      expect(view.html()).toEqual '<p>foo</p>'
       
  
  describe 'visible', ->
    it 'is visibile by default', ->
      expect(new View().visible()).toEqual true
  
    it 'is persists the visibility state', ->
      view = new View()
      view.visible false
      expect(view.visible()).toEqual false
  
    it 'changes the CSS display value to none', ->
      view = new View()
      view.visible false
      expect(view.el.css('display')).toEqual 'none'
  
    it 'changes the CSS display value to empty string', ->
      view = new View()
      view.visible false
      view.visible true
      expect(view.el.css('display')).toEqual ''
  
