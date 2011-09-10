describe 'mvc/view', ->
  View = null
  view = null
  beforeEach ->
    View = core.mvc.View
    view = new View()

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled View, -> new View()

  it 'supports eventing', ->
    expect(-> new View().bind('foo')).not.toThrow()

  it 'is an MVC model', ->
    expect(view instanceof core.mvc.Model).toEqual true 
  

  describe 'default property values', ->
    it 'is enabled by default', ->
      expect(view.enabled()).toEqual true
    
    it 'is visible by default', ->
      expect(view.visible()).toEqual true
  
  describe 'el', ->
    it 'has an el which is a jQuery object', ->
      expect(view.html instanceof Function).toEqual true
    
    it 'has an [element] which is a DOM element', ->
      expect(view.element.tagName).toEqual 'DIV'
    
    it 'takes a custom element in the constructor', ->
      span = $('<span>Foo</span>').get(0)
      view = new View(el:span)
      expect(view.el.get(0)).toEqual span
  
  describe 'tagName', ->
    it 'is a DIV by default', ->
      expect(view.el.get(0).tagName).toEqual 'DIV'
  
    it 'has a custom tag name', ->
      view = new View( tagName:'li' )
      expect(view.el.get(0).tagName).toEqual 'LI'
  
  describe 'classname', ->
    it 'has no class name by default', ->
      expect(view.el.get(0).className).toEqual ''
  
    it 'has a custom class name', ->
      view = new View( className: 'foo bar' )
      expect(view.el.get(0).className).toEqual 'foo bar'
  
  describe 'enabled', ->
    it 'does not have the [disabled] CSS class by default', ->
      expect(view.el.hasClass('core_disabled')).toEqual false
    
    it 'has the [disabled] CSS class when not enabled', ->
      view.enabled false
      expect(view.el.hasClass('core_disabled')).toEqual true
  
    it 'has the [disabled] CSS class when disabled at construction', ->
      view = new View(enabled: false)
      expect(view.el.hasClass('core_disabled')).toEqual true
  
    it 'does not have the [disabled] CSS class when re-enabled', ->
      view.enabled false
      view.enabled true
      expect(view.el.hasClass('core_disabled')).toEqual false
  
  describe 'html', ->
    it 'insert HTML within the view', ->
      view.html '<p>foo</p>'
      expect(view.el.clone().wrap('<div></div>').parent().html()).toEqual '<div><p>foo</p></div>'
  
    it 'reads the views inner HTML', ->
      view.html '<p>foo</p>'
      expect(view.html()).toEqual '<p>foo</p>'
       
  
  describe 'visible', ->
    it 'is a property-function', ->
      expect(view.visible._parent.name).toEqual 'visible'
  
    it 'persists the visibility state', ->
      view.visible false
      expect(view.visible()).toEqual false
  
    it 'changes the CSS display value to none', ->
      view.visible false
      expect(view.el.css('display')).toEqual 'none'
  
    it 'changes the CSS display value to empty string', ->
      view.visible false
      view.visible true
      expect(view.el.css('display')).toEqual ''
  
  describe 'helper functions', ->
    it 'exposes Backbone [make] method', ->
      expect(view.make).toEqual view._.view.make

