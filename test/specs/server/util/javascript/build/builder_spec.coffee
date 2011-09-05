fs = core.util.fs

describe 'util/javascript/build/builder', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample/builder"
  FOLDER_1_PATH = "#{SAMPLE_PATH}/folder1"
  FOLDER_2_PATH = "#{SAMPLE_PATH}/folder2"

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

  describe 'require.js', ->
    it 'loads [require.js] as static property of class', ->
      value = Builder.requireJs
      expect(_.includes(value, 'if (!this.require) {')).toEqual true
    
    
  describe '[files] method', ->
    paths = null
    beforeEach ->
        paths = [
            { path:FOLDER_1_PATH, namespace:'ns2' }
            { path:FOLDER_2_PATH, namespace:'ns1' }
        ]

    it 'retreives all files in all paths, ordered', ->
      builder = new Builder(paths)
      done = no
      builder.build (m) -> done = yes
      waitsFor (-> done is yes), 100
      runs -> 
        files = builder.files()
        expect(files[0].id).toEqual 'ns1/file3'
        expect(files[1].id).toEqual 'ns1/file4'
        expect(files[2].id).toEqual 'ns2/file1'
        expect(files[3].id).toEqual 'ns2/file2'
    
    it 'only adds files that have been built', ->
      builder = new Builder(paths)
      expect(builder.files().length).toEqual 0
    
  
  describe 'build', ->
    paths = null
    beforeEach ->
        paths = [
            { path:FOLDER_1_PATH, namespace:'ns1' }
            { path:FOLDER_2_PATH, namespace:'ns2' }
        ]

    it 'invokes callback immediately when there are no paths', ->
      builder = new Builder()
      called = false
      builder.build -> called = true
      expect(called).toEqual true
    
    it 'builds the collection of paths', ->
        builder = new Builder [{ path:FOLDER_1_PATH }, { path:FOLDER_2_PATH }] 
        done = no
        builder.build (m) -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          paths = builder.paths
          expect(paths[0].isBuilt()).toEqual true
          expect(paths[1].isBuilt()).toEqual true
    
    it 'sets the [isBuilt] flag to true', ->
        builder = new Builder(paths)
        done = no
        builder.build (m) -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          expect(builder.isBuilt).toEqual true
      
    it 'saves the modules to the [code] property', ->
        builder = new Builder(paths)
        done = no
        builder.build (m) -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          code = builder.code
          for file in builder.files()
              includesCode = _(code).includes file.code.moduleProperty
              expect(includesCode).toEqual true
    
    it 'returns the code within the callback.', ->
        builder = new Builder(paths)
        code = null
        builder.build (c) -> code = c
        waitsFor (-> code?), 100
        runs -> 
          expect(code).toEqual builder.code
  
  

  # describe 'save', ->
  #   paths = null
  #   beforeEach ->
  #       paths = [
  #           { path:FOLDER_1_PATH, namespace:'ns1' }
  #           { path:FOLDER_2_PATH, namespace:'ns2' }
  #       ]
  # 
  #   it 'saves the uncompressed file to disk', ->
  #     
  #   








