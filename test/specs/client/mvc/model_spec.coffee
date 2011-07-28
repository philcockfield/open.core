describe 'client/mvc/model', ->
  Model = null
  model = null
  backingModel = null
  SampleModel = null
  beforeEach ->
      Model = core.mvc.Model
      model = null
      
      class SampleModel extends Model
        constructor: () -> 
            super
            @addProps
                    foo: 123
                    bar: null
      
      model = new SampleModel()
      backingModel = model._.model

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()
  
  it 'wraps a Backbone Model', ->
    expect(model._.model instanceof Backbone.Model).toEqual true 

  describe 'Read/Write properties', ->
    it 'reads from the backing model', ->
      spyOn backingModel, 'get'
      model.foo()
      expect(backingModel.get).toHaveBeenCalled()

    it 'writes to the backing model', ->
      spyOn backingModel, 'set'
      model.foo('hello')
      expect(backingModel.set).toHaveBeenCalledWith( foo:'hello')

      
    
    
  
  
