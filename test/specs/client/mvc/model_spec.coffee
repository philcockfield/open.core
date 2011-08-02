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
            @.addProps
                    foo: 123
                    bar: null
      
      model = new SampleModel()
      backboneModel = model._.model
  
  
  it 'supports eventing', ->
     expect(-> model.bind('foo')).not.toThrow()
  
  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()
  
  it 'wraps a Backbone Model', ->
    expect(model._.model instanceof Backbone.Model).toEqual true 

  describe 'Read/Write properties', ->
    it 'GETS from the backing model', ->
      spyOn model, 'get'
      model.foo()
      expect(model.get).toHaveBeenCalled()
    
    it 'SETS to the backing model', ->
      spyOn model, 'set'
      model.foo('hello')
      expect(model.set).toHaveBeenCalledWith( foo:'hello' )
      
    it 'reads from model', ->
      expect(model.foo()).toEqual 123
    
    it 'writes to model', ->
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
    
  describe 'url', ->
    it 'can be overridden', ->
      class MyModel extends Model
        url: -> 'http://foo.com'
      expect(new MyModel().url()).toEqual 'http://foo.com'
      

  describe 'server method wrapping', ->
    it 'wraps [fetch]', ->
      expect(model.fetch._wrapped).toEqual backboneModel.fetch

    it 'wraps [save]', ->
      expect(model.save._wrapped).toEqual backboneModel.save

    it 'wraps [destroy]', ->
      expect(model.destroy._wrapped).toEqual backboneModel.destroy
    
      
  describe 'fetch (and generic server method handler)', ->
    fetchArgs = null
    
    beforeEach ->
      fetchArgs = null
      spyOn(model.fetch, '_wrapped').andCallFake (args) -> fetchArgs = args
    
    
    it 'passes execution to the Backbone.fetch method', ->
      model.fetch()
      expect(model.fetch._wrapped).toHaveBeenCalled()
          
    it 'invokes the success callback', ->
      count = 0
      args = null
      options = 
            success: (e)->  
                count += 1
                args = e
      model.fetch(options)
      fetchArgs.success('model', 'res')
      
      expect(count).toEqual 1
      expect(args.model).toEqual model
      expect(args.response).toEqual 'res'
      expect(args.success).toEqual true
      expect(args.error).toEqual false

    
    it 'invokes the error callback', ->
      count = 0
      args = null
      options = 
            error: (e)->  
                count += 1
                args = e
      model.fetch(options)
      fetchArgs.error('model', 'res')
      
      expect(count).toEqual 1
      expect(args.model).toEqual model
      expect(args.response).toEqual 'res'
      expect(args.success).toEqual false
      expect(args.error).toEqual true
      
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
        expect(args.success).toEqual true
        expect(args.error).toEqual false
    
      it 'passes event-args when completed with error', ->
        model.fetch()
        fetchArgs.error('model', 'res')
        expect(args.model).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual false
        expect(args.error).toEqual true
    
    describe 'handler: onComplete', ->
      it 'invokes callback on success', ->
        args = null
        model.fetch.onComplete (e) -> args = e
        model.fetch()
        fetchArgs.success('model', 'res')
        
        expect(args.model).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual true
        expect(args.error).toEqual false
        
