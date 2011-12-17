describe 'controls/controllers/size', ->
  SizeController  = null
  view            = null
  size            = null

  class MyView extends core.mvc.View
    defaults:
      width: 100
      height: 200
  
  beforeEach ->
    SizeController = controls.controllers.Size
    view           = new core.mvc.View()
    size           = new SizeController view
  
  it 'exists', ->
    expect(SizeController).toBeDefined()
  
  describe 'width/height properties', ->
    it 'adds the [width] property-functions', ->
      expect(view.width.onChanged instanceof Function).toEqual true 
    
    it 'adds the [height] property-functions', ->
      expect(view.height.onChanged instanceof Function).toEqual true 
    
    it 'has null [width] by default', -> expect(view.width()).toEqual null
    it 'has null [height] by default', -> expect(view.height()).toEqual null
  
  
  describe 'Existing width/height properties', ->
    it 'throws if the [width] property is already defined and is not a prop-func', ->
      view       = new core.mvc.View()
      view.width = 123
      expect(-> new SizeController(view)).toThrow()
    
    it 'throws if the [height] property is already defined and is not a prop-func', ->
      view        = new core.mvc.View()
      view.height = 123
      expect(-> new SizeController(view)).toThrow()
    
    describe 'existing property functions', ->
      beforeEach ->
        view = new MyView()
        size = new SizeController view
      it 'uses an [width] property functions', -> expect(view.width()).toEqual 100
      it 'uses an [height] property functions', -> expect(view.height()).toEqual 200
  
  describe 'updating width/height on element STYLE attribute', ->
    describe 'default values', ->
      it 'does not have any style values by default', ->
        expect(view.el.attr('style')).toEqual null
      
      it 'has a default width/height CSS style', ->
        view = new MyView()
        size = new SizeController view
        expect(view.el.css('width')).toEqual '100px'
        expect(view.el.css('height')).toEqual '200px'
      
      it 'has not style with defined width/height properties that are null', ->
        class NullSize extends core.mvc.View
          defaults:
            width:  null
            height: null
        view = new NullSize()
        expect(view.el.attr('style')).toEqual null
    
    it 'updates the element [width] CSS style', ->
      view.width 123
      expect(view.el.css('width')).toEqual '123px'
    
    it 'updates the element [height] CSS style', ->
      view.height 123
      expect(view.el.css('height')).toEqual '123px'
    
    it 'uses an alternative unit', ->
      view = new MyView()
      size = new SizeController view, unit:'%'
      html = view.outerHtml()
      expect(_(html).includes('width: 100%;')).toEqual true
      expect(_(html).includes('height: 200%;')).toEqual true
