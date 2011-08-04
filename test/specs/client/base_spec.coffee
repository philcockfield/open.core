describe 'base', ->
  Base = null
  Property = null
  obj = null
  beforeEach ->
    Base = core.Base
    Property = core.util.Property
    obj = new Base()
  
  describe 'extending from', ->
    it 'extend using underscore', ->
      foo = {}
      _.extend foo, new Base()
      foo.addProps bar: 123
      expect(foo.bar()).toEqual 123
      
    
    
  describe 'addProps', ->
    it 'adds multiple properties to the object', ->
      obj.addProps 
                  foo: 123
                  bar: null
      expect(obj.foo()).toEqual 123
      expect(obj.bar()).toEqual null
   
    it 'does not override an existing property', ->
      obj.foo = 'hello'
      expect(-> obj.addProps( foo:123 )).toThrow()
      expect(obj.foo).toEqual 'hello'
