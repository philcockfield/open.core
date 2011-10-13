describe 'harness/index', ->
  harness = null
  div = '<div></div>'
  
  beforeEach ->
    harness = new Harness()
  
  it 'exists', ->
    # Stored in global context within [spec_helper]
    expect(Harness).toBeDefined()
  
  describe 'init()', ->
    it 'returns the harness instance from init()', ->
      result = harness.init(within:div)
      expect(result).toEqual harness
    
    
  
  
  
  
    
  
  