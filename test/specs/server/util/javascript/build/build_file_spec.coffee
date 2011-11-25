fs     = require 'fs'
fsUtil = core.util.fs
coffee = require 'coffee-script'


describe 'util/javascript/build/build_file', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample/build_path"
  BuildFile = null

  beforeEach ->
    BuildFile = core.util.javascript.BuildFile

  it 'exists', ->
    expect(BuildFile).toBeDefined()

  describe 'constructor', ->
    it 'exposes [path] as property', ->
      buildFile = new BuildFile('foo.js')
      expect(buildFile.path).toEqual 'foo.js'

    it 'is not built by default', ->
      expect(new BuildFile('foo.js').isBuilt).toEqual false

    it 'exposes [extension] as property', ->
      expect(new BuildFile('foo.js').extension).toEqual '.js'
      expect(new BuildFile('foo.coffee').extension).toEqual '.coffee'
    
    it 'exposes the file name (without the .js extension)', ->
      expect(new BuildFile('foo.bar.js').name).toEqual 'foo.bar'
      expect(new BuildFile('/foo.bar.js').name).toEqual 'foo.bar'
      expect(new BuildFile('/path/foo.js').name).toEqual 'foo'
    
    it 'exposes the file name (without the .coffee extension)', ->
      expect(new BuildFile('foo.coffee').name).toEqual 'foo'
      expect(new BuildFile('/foo.bar.coffee').name).toEqual 'foo.bar'
      expect(new BuildFile('/path/foo.coffee').name).toEqual 'foo'
    
    describe 'namespace', ->
      it 'exposes [namespace] as property', ->
        buildFile = new BuildFile('foo.js', 'ns')
        expect(buildFile.namespace).toEqual 'ns'
    
      it 'trims (/) char from end of [namespace] property', ->
        buildFile = new BuildFile('foo.js', '/ns/')
        expect(buildFile.namespace).toEqual '/ns'
      
      it 'converts a null namespace to an empty-string', ->
        buildFile = new BuildFile('foo.coffee', null)
        expect(buildFile.namespace).toEqual ''

      it 'converts an undefined namespace to an empty-string', ->
        buildFile = new BuildFile('foo.coffee')
        expect(buildFile.namespace).toEqual ''

    
    describe 'id', ->
      it 'exposes CommonJS module id : [namespace] + [file-name]', ->
        buildFile = new BuildFile('foo.coffee', 'ns')
        expect(buildFile.id).toEqual 'ns/foo'
      
    
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
    jsPath     = "#{SAMPLE_PATH}/file1.js"
    coffeePath = "#{SAMPLE_PATH}/file2.coffee"
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

    it 'returns the [BuildFile] instance', ->
      buildFile = new BuildFile jsPath
      result = null
      buildFile.build (code, instance) -> result = instance
      waitsFor (-> result?), 100
      runs -> 
        expect(result).toEqual buildFile

    
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
      buildFile = new BuildFile coffeePath
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        compiled = coffee.compile(coffeeFile)
        expect(result.javascript).toEqual compiled
      
    it 'compiles module property', ->
      buildFile = new BuildFile jsPath, 'ns'
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        moduleProperty = """
                         "ns/file1": function(exports, require, module) {
                           var jsFile = "file1.js"
                         }
                         """
        expect(result.moduleProperty).toEqual moduleProperty

    it 'sets the isBuilt flag', ->
      buildFile = new BuildFile jsPath, 'ns'
      result = null
      buildFile.build (code) -> result = code
      waitsFor (-> result?), 100
      runs -> 
        expect(buildFile.isBuilt).toEqual true
      
