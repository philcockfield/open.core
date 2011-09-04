fs = core.util.fs

describe 'util/javascript/build/builder', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample/builder"
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
    
    describe 'paths', ->
      paths = [
        { path: '/foo/1.coffee', namespace: 'foo' }
        { path: '/foo/2.coffee', namespace: 'foo' }
      ]
      
      it 'adds paths to the [paths] property collection', ->
        builder = new Builder(paths)
        expect(builder.paths.length).toEqual 2
      
      it 'converts single path object passed to constructor into an array', ->
        builder = new Builder 
                        path:'foo/1.coffee', 
                        namespace: 'foo'
        expect(builder.paths[0].path).toEqual 'foo/1.coffee'
        expect(builder.paths[0].namespace).toEqual 'foo'
      
      it 'converts the paths parameter into BuildPath instances', ->
        builder = new Builder(paths)
        for path in builder.paths
          expect(path instanceof BuildPath).toEqual true 
      
      it 'has no built paths upon construction', ->
        builder = new Builder(paths)
        for path in builder.paths
          expect(path.isBuilt()).toEqual false
      
      it 'has no paths when empty array passed to constructor', ->
        builder = new Builder([])
        expect(builder.paths).toEqual []

      it 'has no paths when nothing is passed to constructor', ->
        builder = new Builder()
        expect(builder.paths).toEqual []
      
  describe 'build', ->
    # folder1Path
    
    
    it 'builds the collection of paths', ->
        # buildPath = new Builder [ { path:  } ]
        # done = no
        # buildPath.build (m) -> 
        #   buildPath.build (m) -> done = yes
        # waitsFor (-> done is yes), 100
        # runs -> 
        #   expect(buildPath.modules.length).toEqual 5
        #       
        #       
        #       
        #       
        #     
        #     
        #     
        #     
