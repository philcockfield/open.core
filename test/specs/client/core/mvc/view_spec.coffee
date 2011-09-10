describe 'mvc/view', ->
  MyView = null
  View   = null
  view   = null
  beforeEach ->
    View = core.mvc.View
    class MyView extends View
      defaults: 
        foo: 123
        text: null
    view = new MyView()

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

    describe '[replace] method', ->
      html = """
             <div>
                <span class="  foo    bar "></span>
                <span class="prop1" data-foo="456" data-enabled="false" data-text="foo"></span>
                <span class="prop2" data-noProp="value"></span>
                <span id="my_id"></span>
             </div>      
             """
      page = null
      replaceEl = null
      beforeEach ->
          page = $(html)
          view.el.addClass 'my_view'
          view.el.html 'MyView'
      
      it 'calls [toJQuery] conversion util', ->
        selector = null
        spyOn(core.util, 'toJQuery') # .andCallFake (args) -> selector = args
        view.replace '#foo'
        expect(core.util.toJQuery.mostRecentCall.args[0]).toEqual '#foo'
      
      it 'returns the view element', ->
        expect(view.replace('.foo')).toEqual view
      
      describe 'replacing the DOM element', ->
        it 'puts the [view.el] in the DOM', ->
          view.replace page.find('span.foo')
          expect(page.find('.my_view').length).toEqual 1

        it 'removes the replaced element from the DOM', ->
          expect(page.find('span.foo').length).toEqual 1
          view.replace page.find('span.foo')
          expect(page.find('span.foo').length).toEqual 0

        it 'does not fail of the element does not exist', ->
          replaceEl = $('does-not-exist')
          expect(replaceEl.length).toEqual 0
          view.replace replaceEl
        
      describe 'copying the ID property', ->
        beforeEach ->
            replaceEl = page.find('#my_id')
        
        it 'copies the ID from the source element to the [view.el]', ->
          view.replace replaceEl
          expect(view.el.attr('id')).toEqual 'my_id'
        
        it 'does not override an existing ID element on the [view.el]', ->
          view.el.attr 'id', 'foo'
          view.replace replaceEl
          expect(view.el.attr('id')).toEqual 'foo'
        
        it 'does not set an ID to an empty-string', ->
          replaceEl.attr 'id', ''
          view.replace replaceEl
          expect(view.el.attr('id')).not.toBeDefined()
        
        it 'does not set an ID to white-space', ->
          replaceEl.attr 'id', '   '
          view.replace replaceEl
          expect(view.el.attr('id')).not.toBeDefined()
        
        it 'copies the ID to the View', ->
          view.replace replaceEl
          expect(view.id).toEqual 'my_id'
        
        it 'does not effect the Views [id] if one has already been set', ->
          view = new MyView id:'foo'
          view.replace replaceEl
          expect(view.id).toEqual 'foo'
      
      describe 'copying CSS classes', ->
        it 'copies both [foo] and [bar] classes from the replaced element', ->
          view.replace page.find('span.foo')
          expect(view.el.hasClass('foo')).toEqual true
          expect(view.el.hasClass('bar')).toEqual true

        it 'retains the original [my_view] classes from the view', ->
          view.replace page.find('span.foo')
          expect(view.el.hasClass('my_view')).toEqual true
        
        it 'has no classes to copy', ->
          view.replace $('<div>EMPTY</div>')
          expect(view.el.attr('class')).toEqual 'my_view'

        it 'has existing class to copy', ->
          view.replace $('<div class="my_view">EMPTY</div>')
          expect(view.el.attr('class')).toEqual 'my_view'
          
      describe 'copying [data-*] property values', ->
        it 'copies a number property', ->
          view.replace page.find('.prop1')
          value = view.foo()
          expect(value).toEqual 456
          expect(_.isNumber(value)).toEqual true 

        it 'copies and converts a boolean property', ->
          view.replace page.find('.prop1')
          value = view.enabled()
          expect(value).toEqual false
          expect(_.isBoolean(value)).toEqual true 

        it 'copies a string property', ->
          view.replace page.find('.prop1')
          value = view.text()
          expect(value).toEqual 'foo'
          expect(_.isString(value)).toEqual true 
          
        it 'ignore [data-*] values that are not properties of the View', ->
          view.replace page.find('.prop2')
          expect(view.noProp).not.toBeDefined()
        
        
        
      
      
      
      
      





