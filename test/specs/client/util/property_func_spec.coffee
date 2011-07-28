describe 'client/util/property_func', ->
  PropFunc = null
  beforeEach ->
    PropFunc = core.util.PropFunc

  it 'exists', ->
    expect(PropFunc).toBeDefined()
  
  it 'exposes name', ->
    prop = new PropFunc( name:'foo', store: {} )
    expect(prop.name).toEqual 'foo'

  describe 'fn', ->
    it 'supports eventing', ->
      prop = new PropFunc( name:'foo', store: {} )
      prop.bind 'event'
      
    
  
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
    
    