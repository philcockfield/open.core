fs = core.util.fs

describe 'util/javascript/build/builder', ->
  SAMPLE_PATH = "#{core.paths.server}/util/build/sample"
  Builder = null
  beforeEach ->
    Builder = core.util.javascript.Builder
  
  it 'exists', ->
    expect(Builder).toBeDefined()
  
  
  describe 'constructor options', ->
    describe 'defaults', ->
      it 'does not build by default', ->
        builder = new Builder()
        expect(builder.code).not.toBeDefined()
      
      it 'does not include CommonJS require code by default', ->
        builder = new Builder()
        expect(builder.includeRequire).toEqual false
      
    
      
    
    
    
  