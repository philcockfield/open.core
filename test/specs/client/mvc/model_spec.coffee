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
            @.util.addProps
                    foo: 123
                    bar: null
      
      model = new SampleModel()
      backingModel = model._.model

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()
  
  it 'wraps a Backbone Model', ->
    expect(model._.model instanceof Backbone.Model).toEqual true 

  describe 'Read/Write properties', ->
    it 'GETS from the backing model', ->
      spyOn backingModel, 'get'
      model.foo()
      expect(backingModel.get).toHaveBeenCalled()
    
    it 'SETS to the backing model', ->
      spyOn backingModel, 'set'
      model.foo('hello')
      expect(backingModel.set).toHaveBeenCalledWith( foo:'hello' )
      
    it 'reads from model', ->
      expect(model.foo()).toEqual 123
    
    it 'write to model', ->
      model.foo 'yo'
      expect(model.foo()).toEqual 'yo'
    
    describe 'async read/write', ->
      it 'reads from an async callback', ->
        value = null
        read = -> value = model.foo()
        setTimeout read, 5
        waitsFor -> value != null
        runs -> 
          expect(value).toEqual 123
    
      it 'writes from an async callback', ->
        written = false
        write = -> 
                model.bar 'hello'
                written = true
        setTimeout write, 5
        waitsFor -> written == true
        runs -> 
          expect(model.bar()).toEqual 'hello'
    
    
      
      
