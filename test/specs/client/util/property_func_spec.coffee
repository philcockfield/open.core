describe 'client/util/property_func', ->
  PropFunc = null
  beforeEach ->
    PropFunc = core.util.PropFunc

  it 'exists', ->
    expect(PropFunc).toBeDefined()
  
  it 'exposes name', ->
    prop = new PropFunc( name:'foo', store: {} )
    expect(prop.name).toEqual 'foo'
    
  
  describe 'reading values', ->
    it 'reads null value', ->
      prop = new PropFunc( name:'foo', store: {} )
      expect(prop.fn()).toEqual null

    it 'reads default', ->
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      expect(prop.fn()).toEqual 123
    
    it 'defers to the [read] method', ->
      prop = new PropFunc( name:'foo', store: {} )
      spyOn prop, 'read'
      prop.fn()
      expect(prop.read).toHaveBeenCalled()

    it 'does not defer to the [write] method', ->
      prop = new PropFunc( name:'foo', store: {} )
      spyOn prop, 'write'
      prop.fn()
      expect(prop.write).not.toHaveBeenCalled()
    
    
  describe 'writing values', ->
    it 'writes a value', ->
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      prop.fn('abc')
      expect(prop.fn()).toEqual 'abc'

    it 'writes null', ->
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      prop.fn(null)
      expect(prop.fn()).toEqual null

    it 'defers to the [write] method', ->
      prop = new PropFunc( name:'foo', store: {} )
      spyOn prop, 'write'
      prop.fn(123)
      expect(prop.write).toHaveBeenCalled()
      
      
    
  describe 'change event', ->
    prop = null
    args = null
    count = 0
    beforeEach ->
      count = 0
      args = null
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      prop.bind 'change', (e) -> 
            count += 1
            args = e

    describe 'fireChange method', ->
      it 'fires change event from class', ->
        prop.fireChange()
        expect(count).toEqual 1
      
      it 'fires change event from [fn] method', ->
        prop.fireChange()
        expect(count).toEqual 1
      
      it 'passes values as args in event', ->
        prop.fireChange(1, 2)
        expect(args.oldValue).toEqual 1
        expect(args.newValue).toEqual 2
    
    describe 'change event when writing', ->
      it 'fires change event when value is different', ->
        prop.fn('abc')
        expect(count).toEqual 1

      it 'does not fire change event when value is the same (as default)', ->
        prop.fn(123)
        expect(count).toEqual 0

      it 'does not fire change event when value is the same (multiple change with same value)', ->
        prop.fn('abc')
        prop.fn('abc')
        prop.fn('abc')
        expect(count).toEqual 1

      it 'passes the old and new values in event args', ->
        prop.fn('abc')
        expect(args.oldValue).toEqual 123
        expect(args.newValue).toEqual 'abc'
        
        
      
    
    
    
    
    
    
    
    