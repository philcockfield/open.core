fsUtil = core.util.fs

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
        expect(builder.includeRequireJS).toEqual false
      
      it 'does not have a [header] notice by default', ->
        builder = new Builder()
        expect(builder.header).toEqual null
      
      it 'minifies by default', ->
        builder = new Builder()
        expect(builder.minify).toEqual true
      
    
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
      
    it 'stores the code modules within the genearted [code] property', ->
      builder = new Builder(paths)
      done = no
      builder.build (m) -> done = yes
      waitsFor (-> done is yes), 100
      runs -> 
        code = builder.code.standard
        for file in builder.files()
            includesCode = _(code).include file.code.moduleProperty
            expect(includesCode).toEqual true
    
    it 'stores the minified version of the code', ->
      builder = new Builder(paths)
      done = no
      builder.build (m) -> done = yes
      waitsFor (-> done is yes), 100
      runs -> 
        fnCompress = core.util.javascript.minifier.compress
        minified = builder.code.minified
        expect(minified).toEqual fnCompress(builder.code.standard)
    
    it 'does not store the minified version of the code', ->
      builder = new Builder(paths, minify:false)
      done = no
      builder.build (m) -> done = yes
      waitsFor (-> done is yes), 100
      runs -> 
        minified = builder.code.minified
        expect(minified).toEqual null
    
    it 'returns the [code] function within the callback', ->
        builder = new Builder(paths)
        code = null
        builder.build (c) -> code = c
        waitsFor (-> code?), 100
        runs -> 
          expect(code).toEqual builder.code
          expect(code instanceof Function).toEqual true 

    describe '[code] function', ->
      it 'returns the standard code', ->
          builder = new Builder(paths)
          code = null
          builder.build (c) -> code = c
          waitsFor (-> code?), 100
          runs -> 
            expect(code()).toEqual builder.code.standard
            expect(code(false)).toEqual builder.code.standard

      it 'returns the minified code', ->
          builder = new Builder(paths)
          code = null
          builder.build (c) -> code = c
          waitsFor (-> code?), 100
          runs -> 
            expect(code(true)).toEqual builder.code.minified
      
    it 'prepends copyright to both versions of the standard code as the header', ->
        COPYRIGHT = '(c) Copyright'
        builder = new Builder(paths, header:COPYRIGHT)
        code = null
        builder.build (c) -> code = c
        waitsFor (-> code?), 100
        runs -> 
          expect(_(code.standard).startsWith(COPYRIGHT)).toEqual true
          expect(_(code.minified).startsWith(COPYRIGHT)).toEqual true
      
    
    describe 'require.js', ->
      it 'loads [require.js] as static property of class', ->
        expect(_.include(Builder.requireJS, 'if (!this.require) {')).toEqual true
    
      it 'does not include the require JS in the built code', ->
        builder = new Builder(paths)
        code = null
        builder.build (c) -> code = c
        waitsFor (-> code?), 100
        runs -> 
          includes = _(code.standard).include(Builder.requireJS)
          expect(includes).toEqual false
    
      it 'includes the require JS in the built code', ->
        builder = new Builder(paths, { includeRequireJS: true })
        code = null
        builder.build (c) -> code = c
        waitsFor (-> code?), 100
        runs -> 
          includes = _(code.standard).include(Builder.requireJS)
          expect(includes).toEqual true

  describe 'save', ->
    paths = null
    DIR   = "#{SAMPLE_PATH}/save"
    
    beforeEach ->
        paths = [
            { path:FOLDER_1_PATH, namespace:'ns1' }
            { path:FOLDER_2_PATH, namespace:'ns2' }
        ]
    afterEach -> fsUtil.deleteSync DIR
        
    it 'saves the uncompressed file to disk', ->
        builder = new Builder(paths)
        done = no
        builder.save dir:DIR + '///', name:'sample', -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          fileContent = fsUtil.fs.readFileSync("#{DIR}/sample.js").toString()
          expect(fileContent).toEqual builder.code.standard
  
    it 'saves the uncompressed file to disk (stripping the .js suffix)', ->
        builder = new Builder(paths)
        done = no
        builder.save dir:DIR, name:'sample.foo.js', -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          fileContent = fsUtil.fs.readFileSync("#{DIR}/sample.foo.js").toString()
          expect(fileContent).toEqual builder.code.standard

    it 'saves the compressed file to disk', ->
        builder = new Builder(paths)
        done = no
        builder.save dir:DIR + '///', name:'sample', -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          fileContent = fsUtil.fs.readFileSync("#{DIR}/sample-min.js").toString()
          fileContent = core.util.javascript.minifier.compress(fileContent)
          expect(fileContent).toEqual builder.code.minified
          
    it 'does not re-build the code if already built', ->
        builder = new Builder(paths, { includeRequireJS: true })
        spyOn(builder, 'build').andCallThrough()
        
        done = no
        builder.build -> 
          builder.save dir:DIR, name:'sample', -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          expect(builder.build.callCount).toEqual 1

    it 'returns a [code] function object', ->
        builder = new Builder(paths)
        result = null
        builder.save dir:DIR, name:'sample', (code) -> result = code
        waitsFor (-> result?), 100
        runs -> 
          expect(result(true)).toEqual builder.code.minified

    it 'stores the save paths on the returned [code] object', ->
        builder = new Builder(paths)
        result = null
        builder.save dir:DIR, name:'sample', (code) -> result = code
        waitsFor (-> result?), 100
        runs -> 
          expect(result.paths.standard).toEqual "#{DIR}/sample.js"
          expect(result.paths.minified).toEqual "#{DIR}/sample-min.js"
          

        





