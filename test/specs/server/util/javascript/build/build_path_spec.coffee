fs     = require 'fs'
fsUtil = core.util.fs

describe 'util/javascript/build/build_path', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample"
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

      it 'does not perform a deep build if the path is a file', ->
        buildPath = new BuildPath source:'foo.js'
        expect(buildPath.deep).toEqual false
      
      it 'null source by default', ->
        expect(buildPath.source).toEqual null
        
      it 'null namespace by default', ->
        expect(buildPath.namespace).toEqual null
      
      it 'has no modules by default', ->
        expect(buildPath.modules).toEqual []
      
    describe 'storing options as properties', ->
      it 'stores source path as property', ->
        buildPath = new BuildPath source:'foo'
        expect(buildPath.source).toEqual 'foo'
      
      it 'stores namespace as property', ->
        buildPath = new BuildPath namespace:'ns'
        expect(buildPath.namespace).toEqual 'ns'

      it 'stores deep flag as property', ->
        buildPath = new BuildPath deep:false
        expect(buildPath.deep).toEqual false
    
    describe 'path type flags', ->
      it 'is a folder', ->
        buildPath = new BuildPath source:'/foo/bar'
        expect(buildPath.isFolder).toEqual true
        expect(buildPath.isFile).toEqual false

      it 'is a file', ->
        buildPath = new BuildPath source:'/foo/bar.js'
        expect(buildPath.isFolder).toEqual false
        expect(buildPath.isFile).toEqual true
      
  describe '[build] method', ->
    def1 = { source: "#{SAMPLE_PATH}/file.js" }
    def2 = { source: "#{SAMPLE_PATH}/file.coffee" }
    jsFile     = fs.readFileSync(def1.source).toString()
    coffeeFile = fs.readFileSync(def2.source).toString()

    describe 'building single files', ->
      it 'stores a built [BuildFile] instance in the modules collection', ->
        buildPath = new BuildPath def2
        modules = null
        buildPath.build (m) -> modules = m
        waitsFor (-> modules?), 100
        runs -> 
          expect(modules.length).toEqual 1
          buildFile = modules[0]
          expect(buildFile.path).toEqual def2.source
          expect(buildFile.isBuilt).toEqual true
      
      
      
      # it 'stores the raw javascript on the code object', ->
      #   buildPath = new BuildPath def1
      #   result = null
      #   buildPath.build (code) -> result = code
      #   waitsFor (-> result?), 100
      #   runs -> 
      #     expect(result.javascript).toEqual jsFile
      # 
      # it 'returns code object property', ->
      #   buildPath = new BuildPath def1
      #   result = null
      #   buildPath.build (code) -> result = code
      #   waitsFor (-> result?), 100
      #   runs -> 
      #     expect(result).toEqual buildPath.code
      #   
      # it 'stores raw coffee-script on the code object', ->
      #   buildPath = new BuildPath def2
      #   result = null
      #   buildPath.build (code) -> result = code
      #   waitsFor (-> result?), 100
      #   runs -> 
      #     expect(result.coffeescript).toEqual coffeeFile
      # 
      # it 'compiles coffee-script to javascript and stores it on the code object', ->
      #   compiled = """
      #               (function() {
      #                 var coffeeFile;
      #                 coffeeFile = 'file.coffee';
      #               }).call(this);
      #               
      #              """
      #   
      #   buildPath = new BuildPath def2
      #   result = null
      #   buildPath.build (code) -> result = code
      #   waitsFor (-> result?), 100
      #   runs -> 
      #     expect(result.javascript).toEqual compiled
      #   
      #   
