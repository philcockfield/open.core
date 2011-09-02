fs = core.util.fs

describe 'util/javascript/build/builder', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample"
  Builder     = null
  BuildPath   = null
  
  beforeEach ->
    Builder   = core.util.javascript.Builder
    BuildPath = core.util.javascript.BuildPath
  
  it 'exists', ->
    expect(Builder).toBeDefined()
  
  
  describe 'constructor options', ->
    describe 'defaults', ->
      it 'does not include CommonJS require code by default', ->
        builder = new Builder()
        expect(builder.includeRequire).toEqual false
      
    
    it 'converts the paths parameter into BuildPath instances', ->
      paths = [
        { source: '/foo/1.coffee', namespace: 'foo' }
        { source: '/foo/2.coffee', namespace: 'foo' }
      ]
      builder = new Builder(paths)
      for path in builder.paths
        expect(path instanceof BuildPath).toEqual true 
      
      
    
    
    
  