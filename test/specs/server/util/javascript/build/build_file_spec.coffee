fs     = require 'fs'
fsUtil = core.util.fs

describe 'util/javascript/build/build_path', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample"
  BuildFile = null

  beforeEach ->
    BuildFile = core.util.javascript.BuildFile

  it 'exists', ->
    expect(BuildFile).toBeDefined()

  describe 'constructor', ->
    it 'exposes [filePath] as property', ->
      buildFile = new BuildFile('foo.js')
      expect(buildFile.filePath).toEqual 'foo.js'
    
    describe 'path type flags', ->
      it 'is a javascript file', ->
        buildFile = new BuildFile '/foo/bar.js'
        expect(buildFile.isJavascript).toEqual true
        expect(buildFile.isCoffee).toEqual false
        
      it 'is a coffee-script file', ->
        buildFile = new BuildFile '/foo/bar.coffee'
        expect(buildFile.isJavascript).toEqual false
        expect(buildFile.isCoffee).toEqual true
      
      it 'throws if not supported file type', ->
        expect(-> new BuildFile '/foo.txt').toThrow()
  
  describe '[build] method', ->
    jsPath     = "#{SAMPLE_PATH}/file.js"
    coffeePath = "#{SAMPLE_PATH}/file.coffee"
    jsFile     = fs.readFileSync(jsPath).toString()
    coffeeFile = fs.readFileSync(coffeePath).toString()
    
    it 'stores the raw javascript on the code object', ->
      buildFile = new BuildFile jsPath
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        expect(result.javascript).toEqual jsFile
    
    it 'returns the [code] object property', ->
      buildFile = new BuildFile jsPath
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        expect(result).toEqual buildFile.code
    
    it 'does not fail if no callback was passed', ->
      buildFile = new BuildFile jsPath
      buildFile.build()
      
    it 'stores raw coffee-script on the code object', ->
      buildFile = new BuildFile coffeePath
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        expect(result.coffeescript).toEqual coffeeFile
    
    it 'compiles coffee-script to javascript and stores it on the code object', ->
      compiled = """
                  (function() {
                    var coffeeFile;
                    coffeeFile = 'file.coffee';
                  }).call(this);
                  
                 """
      
      buildFile = new BuildFile coffeePath
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        expect(result.javascript).toEqual compiled
      
      
      
