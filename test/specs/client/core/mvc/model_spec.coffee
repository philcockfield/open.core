describe 'mvc/model', ->
  Model = null
  model = null
  SampleModel = null
  beforeEach ->
      Model = core.mvc.Model
      model = null
      
      class SampleModel extends Model
        defaults:
            foo: 123
            bar: null
        
        constructor: () -> 
            super
      
      model = new SampleModel()

  it 'is a Backbone model', ->
    expect(model instanceof Backbone.Model).toEqual true 
  
  it 'supports eventing', ->
     expect(-> model.bind('foo')).not.toThrow()
  
  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()
  
  it 'exposes [atts] alias to [attributes] property', ->
    expect(model.atts).toEqual model.attributes
  
  
  describe 'adding [defaults] as Property functions', ->
    it 'takes the elements in "defaults" and converts them to Property functions', ->
      for key of model.defaults
        expect(model[key] instanceof Function).toEqual true 
    
    it 'does nothing when there are no defaults', ->
      class MyModel extends Model
      model = new MyModel()
      expect(model.defaults).not.toBeDefined()
      
    it 'overrides default property from child constructor', ->
      class Father extends Model
        defaults: 
            foo: 123

      class Son extends Model
        constructor: -> 
            super
            @addProps
                foo: 'abc'
            
      father = new Father()
      son = new Son()
      expect(father.foo()).toEqual 123
      expect(son.foo()).toEqual 'abc'
    

  describe 'Read/Write properties', ->
    it 'GETS from the backing model', ->
      spyOn model, 'get'
      model.foo()
      expect(model.get).toHaveBeenCalled()
    
    it 'SETS to the backing model', ->
      values = null
      options = null
      spyOn(model, 'set').andCallFake (v, o) -> 
              values = v
              options = o
      model.foo('hello')
      expect(values.foo).toEqual 'hello'
      expect(options.silent).toEqual false
      
    it 'SETS to the backing model, passing [options]', ->
      values = null
      options = null
      spyOn(model, 'set').andCallFake (v,o) -> 
              values = v
              options = o
      model.foo('hello', silent:true)
      expect(values.foo).toEqual 'hello'
      expect(options.silent).toEqual true
      
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
    beforeEach ->
      spyOn(model, '_sync')
    
    it 'wraps [fetch]', ->
      model.fetch()
      expect(model._sync).toHaveBeenCalled()
  
    it 'wraps [save]', ->
      model.save()
      expect(model._sync).toHaveBeenCalled()
      
    it 'wraps [destroy]', ->
      model.destroy()
      expect(model._sync).toHaveBeenCalled()
    
  describe 'fetch (and generic server method handler)', ->
    fetchArgs = null
    
    beforeEach ->
      fetchArgs = null
      spyOn(Backbone.Model.prototype, 'fetch').andCallFake (args) -> fetchArgs = args
    
    it 'passes execution to the Backbone.fetch method', ->
      model.fetch()
      expect(Backbone.Model.prototype.fetch).toHaveBeenCalled()
          
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
      expect(args.source).toEqual model
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
      expect(args.source).toEqual model
      expect(args.response).toEqual 'res'
      expect(args.success).toEqual false
      expect(args.error).toEqual true
      
    describe 'event: start', ->
      fireCount = 0
      args = null
      beforeEach ->
        fireCount = 0
        args = null
        model.fetch.unbind()
        model.fetch.bind 'start', (e) -> 
              fireCount += 1
              args = e

      it 'fires event when starting', ->
        model.fetch()
        expect(fireCount).toEqual 1

      it 'passes source in args', ->
        model.fetch()
        expect(args.source).toEqual model
        

    
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
        expect(args.source).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual true
        expect(args.error).toEqual false
    
      it 'passes event-args when completed with error', ->
        model.fetch()
        fetchArgs.error('model', 'res')
        expect(args.source).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual false
        expect(args.error).toEqual true
    
    describe 'handler: onComplete', ->
      it 'invokes callback on success', ->
        args = null
        model.fetch.onComplete (e) -> args = e
        model.fetch()
        fetchArgs.success('model', 'res')
        
        expect(args.source).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual true
        expect(args.error).toEqual false

      it 'invokes callback on error', ->
        args = null
        model.fetch.onComplete (e) -> args = e
        model.fetch()
        fetchArgs.error('model', 'res')
        
        expect(args.source).toEqual model
        expect(args.response).toEqual 'res'
        expect(args.success).toEqual false
        expect(args.error).toEqual true

    describe 'handler: onStart', ->
      it 'invokes callback upon starting a fetch operation', ->
        args = null
        model.fetch.onStart (e) -> args = e
        model.fetch()
        expect(args.source).toEqual model

  describe '.identifier() method', ->
    it 'returns the [id] when present', ->
      model = new Model id:'foo'
      expect(model.identifier()).toEqual 'foo'
      
    it 'returns the [cid] when the [id] has not been set', ->
      model = new Model()
      expect(model.identifier()).toEqual model.cid
    
    
    
    
