describe 'util/javascript/build/build_path', ->
  BuildPath = null
  beforeEach ->
    BuildPath = core.util.javascript.BuildPath

  it 'exists', ->
    expect(BuildPath).toBeDefined()
    
  describe 'construction', ->
    describe 'default values', ->
      buildPath = null
      beforeEach -> buildPath = new BuildPath()

      it 'performs deep builds by default', ->
        expect(buildPath.deep).toEqual true
      
      it 'null source by default', ->
        expect(buildPath.source).toEqual null
        
      it 'null namespace by default', ->
        expect(buildPath.namespace).toEqual null
      
    it 'stores source path as property', ->
      buildPath = new BuildPath(source:'foo')
      expect(buildPath.source).toEqual 'foo'
      
    it 'stores namespace as property', ->
      buildPath = new BuildPath(namespace:'ns')
      expect(buildPath.namespace).toEqual 'ns'
      
      
    
        
      
        
  