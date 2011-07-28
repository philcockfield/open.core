describe 'client/base', ->
  Base = null
  PropFunc = null
  obj = null
  beforeEach ->
    Base = core.Base
    PropFunc = core.util.PropFunc
    obj = new Base()

  it 'supports eventing', ->
    expect(-> obj.bind('foo')).not.toThrow()
  
  describe '_ (internal state object)', ->
    it 'exists', ->
      expect(obj._).toBeDefined()

    it 'can merge objects into itself', ->
      obj._.merge { foo:123, bar:null }
      expect(obj._.foo).toEqual 123
      expect(obj._.bar).toEqual null
      
  describe 'util', ->
    it 'merges parameters', ->
      class Parent extends Base
        constructor: (@params) ->

      class Child extends Parent
        constructor: (@params) ->
          super @util.merge @params, { bar:456 }

      obj = new Child(foo:123)
      expect(obj.params.foo).toEqual 123
      expect(obj.params.bar).toEqual 456

    it 'throws when merging in existing parameter', ->
      source = { foo:123 }
      target = { foo:'abc' }
      expect(-> obj.util.merge(source, target)).toThrow()
    
  describe 'addProps', ->
    it 'adds multiple properties to the object', ->
      obj.addProps 
                  foo: 123
                  bar: null
      expect(obj.foo()).toEqual 123
      expect(obj.bar()).toEqual null
     
    it 'does not override an existing property', ->
      obj.foo = 'hello'
      expect(-> obj.addProps(foo:123)).toThrow()
      expect(obj.foo).toEqual 'hello'
        
        
      

