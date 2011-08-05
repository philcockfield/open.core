describe 'mvc/collection', ->
  Collection  = null
  col = null
  SampleModel = null
  beforeEach ->
      Collection = core.mvc.Collection
      class SampleModel extends core.mvc.Model
        constructor: () -> 
            super
            @.addProps(foo: 123)

      col = new Collection()


  it 'is a Backbone model', ->
    expect(col instanceof Backbone.Collection).toEqual true 
  
  it 'supports eventing', ->
     expect(-> col.bind('foo')).not.toThrow()
  
  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Collection, -> new Collection()
  
  describe 'adding', ->
    it 'adds a model to the collection', ->
      m = new SampleModel()
      col.add m
      expect(col.include(m)).toEqual true
    

  describe 'Events', ->
    it 'does not fire the add event when working with different collections', ->
      model = new SampleModel()
      model.col1 = new Collection()
      model.col2 = new Collection()

      args1 = undefined
      args2 = undefined
      model.col1.bind 'add', (e) -> args1 = e
      model.col2.bind 'add', (e) -> args2 = e

      model.col1.add { foo: 1 }
      expect(args1).toBeDefined()
      expect(args2).not.toBeDefined()

    describe 'fetch events', ->
      col = null
      success = false
      error = false
      beforeEach ->
          success = false
          error = false
        
          # Suppress call to server and invoke callbacks
          success = false
          spyOn(Backbone, 'sync').andCallFake (method, model, options) ->
                                                        options?.success?() if success
                                                        options?.error?() if not success
          col = new Collection()
          col.url = '/foo/'
    
      it 'calls fetch on base class', ->
        spyOn Backbone.Collection.prototype, 'fetch'
        col.fetch()
        expect(Backbone.Collection.prototype.fetch).toHaveBeenCalled()
    
      it 'invokes success callback', ->
        count = 0
        success = true
        col.fetch
            success: -> count += 1
        expect(count).toEqual 1
          
      it 'invokes error callback', ->
        count = 0
        error = true
        col.fetch
              error: -> count += 1
        expect(count).toEqual 1
    
      it 'fires [start]', ->
        count = 0
        col.fetch.bind 'start', -> count += 1
        col.fetch()
        expect(count).toEqual 1
    
      it 'fires [complete] successfully', ->
        count = 0
        e = null
        success = true
        col.fetch.bind 'complete', (args) ->
                    count += 1
                    e = args
        col.fetch()
        expect(count).toEqual 1
        expect(e.source).toEqual col
        expect(e.success).toEqual true
        expect(e.error).toEqual false
    
      it 'fires [complete] failed', ->
            count = 0
            e = null
            success = false
            col.fetch.bind 'complete', (args) ->
                        count += 1
                        e = args
            col.fetch()
            expect(count).toEqual 1
            expect(e.source).toEqual col
            expect(e.success).toEqual false
            expect(e.error).toEqual true
        
      it 'invokes handler from [onFetched] method', ->
        count1 = 0
        count2 = 0
        success = false
    
        col.onFetched -> count1 += 1
        col.onFetched -> count2 += 1
    
        col.fetch()
        expect(count1).toEqual 1
        expect(count2).toEqual 1
        
