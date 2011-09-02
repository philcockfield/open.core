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
      it 'is a javascript file', ->
        buildPath = new BuildPath source:'/foo/bar.js'
        expect(buildPath.isJavascript).toEqual true
        expect(buildPath.isCoffee).toEqual false
        expect(buildPath.isFolder).toEqual false
        expect(buildPath.isFile).toEqual true
        
      it 'is a coffee-script file', ->
        buildPath = new BuildPath source:'/foo/bar.coffee'
        expect(buildPath.isJavascript).toEqual false
        expect(buildPath.isCoffee).toEqual true
        expect(buildPath.isFolder).toEqual false
        expect(buildPath.isFile).toEqual true
        
      it 'is a folder file', ->
        buildPath = new BuildPath source:'/foo/bar'
        expect(buildPath.isJavascript).toEqual false
        expect(buildPath.isCoffee).toEqual false
        expect(buildPath.isFolder).toEqual true
        expect(buildPath.isFile).toEqual false

      it 'is a file', ->
        buildPath = new BuildPath source:'/foo/bar.js'
        expect(buildPath.isFolder).toEqual false
        expect(buildPath.isFile).toEqual true
      
  describe '[build] method', ->
    describe 'building a .js file', ->
      def = {
        source: "#{SAMPLE_PATH}/file.js"
      }
      buildPath = null
      jsFile = fs.readFileSync(def.source).toString()
      beforeEach -> buildPath = new BuildPath def
      
      it 'stores the raw javascript on the code object', ->
        result = null
        buildPath.build (code) -> result = code
        waitsFor (-> result?), 100
        runs -> 
          expect(result.javascript).toEqual jsFile
        
        
      
      
          
      
      
      
      
        
        
      
        
  