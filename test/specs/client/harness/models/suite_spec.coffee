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
  
  
  describe 'id', ->
    describe 'root id', ->
      it 'has no id', ->
        expect(new Suite().id).toEqual null
      
      it 'uses the spec title as the id', ->
        expect(new Suite(['foo']).id).toEqual 'foo'
      
      it 'escapes the title', ->
        expect(new Suite('foo bar').id).toEqual 'foo%20bar'
      
      it 'replaces / with escaped \\ character', ->
        expect(new Suite('foo/bar').id).toEqual 'foo%5Cbar'
      
      describe 'id hierarchy', ->
        suite1 = null
        suite2 = null
        suite3 = null
        beforeEach ->
            suite1 = new Suite ['root']
            suite2 = new Suite ['child'], suite1
            suite3 = new Suite ['grand/child'], suite2
        
        it 'contains two level path', ->
          expect(suite2.id).toEqual 'root/child'
        
        it 'contains three level path with escapes', ->
          expect(suite3.id).toEqual 'root/child/grand%5Cchild'
  
  
  describe 'hierarchy', ->
    root       = null
    child      = null
    grandChild = null
    
    beforeEach ->
        root       = new Suite()
        child      = new Suite([], root)
        grandChild = new Suite([], child)
    
    describe 'ancestors()', ->
      it 'retrieves the list of ancestors, including the current one (ascending by default)', ->
        list = grandChild.ancestors()
        expect(list.length).toEqual 3
        expect(list[0]).toEqual grandChild
        expect(list[1]).toEqual child
        expect(list[2]).toEqual root
      
      it 'retrieves the list of ancestors, including the current one (descending)', ->
        list = grandChild.ancestors(direction:'descending')
        expect(list.length).toEqual 3
        expect(list[0]).toEqual root
        expect(list[1]).toEqual child
        expect(list[2]).toEqual grandChild
      
      it 'retrieves the list of ancestors, not including the current one', ->
        list = grandChild.ancestors(includeThis: false)
        expect(list.length).toEqual 2
        expect(list[0]).toEqual child
        expect(list[1]).toEqual root
      
      it 'retrieves single item list with current root suite', ->
        list = root.ancestors()
        expect(list.length).toEqual 1
        expect(list[0]).toEqual root
      
      it 'retrieves empty list', ->
        list = root.ancestors(includeThis: false)
        expect(list.length).toEqual 0
    
    describe 'root()', ->
      it 'retrieves root from grand-child', ->
        expect(grandChild.root()).toEqual root
      
      it 'retrieves the same suite if it is already the root', ->
        expect(root.root()).toEqual root
  
  
  


