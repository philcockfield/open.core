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
    
  describe 'writing values', ->
    it 'writes a value', ->
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      prop.fn('abc')
      expect(prop.fn()).toEqual 'abc'

    it 'writes null', ->
      prop = new PropFunc( name:'foo', store: {}, default:123 )
      prop.fn(null)
      expect(prop.fn()).toEqual null

    
    