describe 'client/mvc/model', ->
  Model = null
  model = null
  backboneModel = null
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
      backboneModel = model._.model

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()
  
  it 'wraps a Backbone Model', ->
    expect(model._.model instanceof Backbone.Model).toEqual true 

  describe 'Read/Write properties', ->
    it 'GETS from the backing model', ->
      spyOn backboneModel, 'get'
      model.foo()
      expect(backboneModel.get).toHaveBeenCalled()
    
    it 'SETS to the backing model', ->
      spyOn backboneModel, 'set'
      model.foo('hello')
      expect(backboneModel.set).toHaveBeenCalledWith( foo:'hello' )
      
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
    
      
  describe 'fetch', ->
    fetchArgs = null
    
    beforeEach ->
      fetchArgs = null
      spyOn(backboneModel, 'fetch').andCallFake (args) -> 
          fetchArgs = args
    
    it 'passes execution to the Backbone.fetch method', ->
      model.fetch()
      expect(backboneModel.fetch).toHaveBeenCalled()
          
    it 'invokes the success callback', ->
      count = 0
      callbackModel = null
      callabackResponse = null
      options = 
            success: (m, r)->  
                count += 1
                callbackModel = m
                callabackResponse = r
      model.fetch(options)
      fetchArgs.success('model', 'res')
      expect(count).toEqual 1
      expect(callbackModel).toEqual model
      expect(callabackResponse).toEqual 'res'
    
    it 'invokes the error callback', ->
      count = 0
      callbackModel = null
      callabackResponse = null
      options = 
            error: (m, r)->  
                count += 1
                callbackModel = m
                callabackResponse = r
      model.fetch(options)
      fetchArgs.error('model', 'res')

      expect(count).toEqual 1
      expect(callbackModel).toEqual model
      expect(callabackResponse).toEqual 'res'
      
    describe 'event: complete', ->
      fireCount = 0
      args = null
      beforeEach ->
        fireCount = 0
        args = null
        model.fetch.unbind()
        model.fetch.bind 'complete', (e) -> 
              fireCount += 1
              args = e
      
      it 'fires event when completed successfully', ->
        model.fetch()
        fetchArgs.success()
        expect(fireCount).toEqual 1

      it 'fires event when completed with error', ->
        model.fetch()
        fetchArgs.error()
        expect(fireCount).toEqual 1
        
      it 'passes event-args when completed successfully', ->
        model.fetch()
        fetchArgs.success('model', 'res')
        expect(args.model).toEqual model
        expect(args.response).toEqual 'res'

      it 'passes event-args when completed with error', ->
        model.fetch()
        fetchArgs.error('model', 'res')
        expect(args.model).toEqual model
        expect(args.response).toEqual 'res'

    # describe 'handler: onComplete', ->
    #   it 'invokes callback on success', ->
    #     args = null
    #     model.fetch.onComplete (e) -> args = e
    #     model.fetch()
    #     fetchArgs.success('model', 'res')
    #     
    #     expect(args.model).toEqual 'model'
        
      
      
        
    
        
      
      













