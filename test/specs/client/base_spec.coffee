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


  describe 'onPropAdded (optional override)', ->
    prop = null
    invokeCount = 0
    beforeEach ->
        prop = null
        invokeCount = 0
        class Custom extends Base
            onPropAdded: (args) -> 
                    prop = args
                    invokeCount += 1
        obj = new Custom()
        spyOn(obj, 'onPropAdded').andCallThrough()
    
    it 'calls [onPropAdded] if decalared', ->
      obj.addProps
          myProp: 123
      expect(obj.onPropAdded).toHaveBeenCalled()
      expect(invokeCount).toEqual 1
      
    it 'passes the added property', ->
      obj.addProps
          myProp: 123
      expect(prop.name).toEqual 'myProp'
      

  describe 'onChanged  (optional override)', ->
    Custom = null
    args = null
    invokeCount = 0
    beforeEach ->
        args = null
        invokeCount = 0
        class Custom extends Base
          onChanged: (e) -> 
                args = e
                invokeCount += 1
        obj = new Custom()
        obj.addProps foo:null
          
    it 'invokes the [onChanged] method once', ->
      obj.foo 123
      expect(invokeCount).toEqual 1
    
    
    
    
    
    
    
    
    
    