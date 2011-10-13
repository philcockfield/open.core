describe 'harness/models/suite', ->
  harness = null
  Suite   = null
  
  beforeEach ->
      harness = new Harness().init('<div></div>')
      Suite = harness.models.Suite
  
  it 'exists', ->
    expect(harness.models.Suite).toBeDefined()
  
  describe 'construction', ->
    it 'has no title', ->
      suite = new Suite()
      expect(suite.title()).toEqual null

    it 'has a title', ->
      suite = new Suite(['foo'])
      expect(suite.title()).toEqual 'foo'
      
    it 'has a summary', ->
      suite = new Suite(['foo', 'bar'])
      expect(suite.summary()).toEqual 'bar'

    it 'has no summary', ->
      suite = new Suite(['foo', -> ])
      expect(suite.summary()).toEqual null
      
    it 'has a func, with no summary', ->
      fn = -> 
      suite = new Suite(['foo', fn ])
      expect(suite.func()).toEqual fn
      
    it 'has a func and summary', ->
      fn = -> 
      suite = new Suite(['foo', 'bar', fn ])
      expect(suite.summary()).toEqual 'bar'
      expect(suite.func()).toEqual fn
    
    it 'has a func only', ->
      fn = -> 
      suite = new Suite([fn])
      expect(suite.func()).toEqual fn
    
    it 'has a [parentSuite] with no param settings', ->
      parent = new Suite()
      suite = new Suite([], parent)
      expect(suite.parentSuite).toEqual parent
  
  
  describe 'hierarchy', ->
    root       = null
    child      = null
    grandChild = null
    
    beforeEach ->
        root       = new Suite()
        child      = new Suite([], root)
        grandChild = new Suite([], child)
    
    describe 'ancestors()', ->
      it 'retrieves the list of ancestors, including the current one', ->
        list = grandChild.ancestors()
        expect(list.length).toEqual 3
        expect(list[0]).toEqual grandChild
        expect(list[1]).toEqual child
        expect(list[2]).toEqual root
      
      it 'retrieves the list of ancestors, not including the current one', ->
        list = grandChild.ancestors(false)
        expect(list.length).toEqual 2
        expect(list[0]).toEqual child
        expect(list[1]).toEqual root
      
      it 'retrieves single item list with current root suite', ->
        list = root.ancestors()
        expect(list.length).toEqual 1
        expect(list[0]).toEqual root
      
      it 'retrieves empty list', ->
        list = root.ancestors(false)
        expect(list.length).toEqual 0
    
    describe 'root()', ->
      it 'retrieves root from grand-child', ->
        expect(grandChild.root()).toEqual root
      
      it 'retrieves the same suite if it is already the root', ->
        expect(root.root()).toEqual root
        
      
      
      
      
    
    
      
    
    
    
  
  
  