describe 'core/mvc/data_binder', ->
  DataBinder = undefined
  view = null
  model = null
  beforeEach ->
      DataBinder = core.mvc.DataBinder
      
      class MyModel extends core.mvc.Model
        defaults:
            foo: 123
      
      class MyView extends core.mvc.View
      
      model = new MyModel()
      view = new MyView()
      
      
  
  it 'exists', ->
    expect(DataBinder).toBeDefined()
  
  describe 'jQuery conversion', ->
    it 'converts view to jQuery object', ->
      spyOn(core.util, 'toJQuery').andCallThrough()
      binder = new DataBinder(model, view)
      expect(core.util.toJQuery).toHaveBeenCalled()
    
    it 'constructs with a CSS selector', ->
      binder = new DataBinder(model, 'body')
      expect(binder.el).toEqual $('body')
      
    it 'constructs with a jQuery object', ->
      elBody = $('body')
      binder = new DataBinder(model, elBody)
      expect(binder.el).toEqual elBody

    it 'constructs with a HTMLElement object', ->
      elBody = $('body').get(0)
      binder = new DataBinder(model, elBody)
      expect(binder.el).toEqual $(elBody)

    it 'constructs with a View object', ->
      view = new core.mvc.View()
      binder = new DataBinder(model, view)
      expect(binder.el).toEqual view.el
      
      
    
  