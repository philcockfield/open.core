fs     = require 'fs'
fsUtil = core.util.fs

describe 'util/javascript/build/build_path', ->
  SAMPLE_PATH = "#{core.paths.specs}/server/util/javascript/build/sample/build_path"
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
        
      it 'empty-string namespace by default', ->
        expect(buildPath.namespace).toEqual ''

      it 'formats namspace', ->
        expect(new BuildPath(namespace:'/ns//').namespace).toEqual '/ns'
      
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
    def1       = { source: "#{SAMPLE_PATH}/file1.js",     namespace:'ns1' }
    def2       = { source: "#{SAMPLE_PATH}/file2.coffee", namespace:'ns2' }
    def3       = { source: SAMPLE_PATH, namespace:'ns'  }
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
      
      it 'passes namespace to the [BuildFile] module', ->
        buildPath = new BuildPath def2
        modules = null
        buildPath.build (m) -> modules = m
        waitsFor (-> modules?), 100
        runs -> 
          expect(modules[0].namespace).toEqual 'ns2'

      it 'returns the [modules] property within the callback', ->
        buildPath = new BuildPath def2
        modules = null
        buildPath.build (m) -> modules = m
        waitsFor (-> modules?), 100
        runs -> 
          expect(modules).toEqual buildPath.modules
    
    describe 'building a folder', ->
      it 'build all files in folder, but not child folders (deep = false)', ->
        def3.deep = false
        buildPath = new BuildPath def3
        modules = null
        buildPath.build (m) -> modules = m
        waitsFor (-> modules?), 100
        runs -> 
          expect(modules.length).toEqual 2
          for m in modules
            expect(m.isBuilt).toEqual true

      it 'builds all descendent children and stores them alphabetically (deep = true)', ->
        def3.deep = true
        buildPath = new BuildPath def3
        modules = null
        buildPath.build (m) -> modules = m
        waitsFor (-> modules?), 100
        runs -> 
          expect(modules.length).toEqual 5
          
          expect(modules[0].id).toEqual 'ns/file1'
          expect(modules[1].id).toEqual 'ns/file2'
          expect(modules[2].id).toEqual 'ns/folder1/child1'
          expect(modules[3].id).toEqual 'ns/folder1/foo/bar'
          expect(modules[4].id).toEqual 'ns/folder2/baz'
      
      it 'resets the [modules] collection on each call to [build]', ->
        def3.deep = true
        buildPath = new BuildPath def3
        done = no
        buildPath.build (m) -> 
          buildPath.build (m) -> done = yes
        waitsFor (-> done is yes), 100
        runs -> 
          expect(buildPath.modules.length).toEqual 5


  describe 'isBuilt', ->
    it 'is not built when the modules is empty', ->
      buildPath = new BuildPath()
      expect(buildPath.modules.length).toEqual 0
      expect(buildPath.isBuilt()).toEqual false
      
    it 'is not built if one module does not have the [isBuilt] flag set to true', ->
      buildPath = new BuildPath()
      buildPath.modules = [ { isBuilt: true }, { isBuilt: false } ]
      expect(buildPath.isBuilt()).toEqual false

    it 'is  built if all modules have the [isBuilt] flag set to true', ->
      buildPath = new BuildPath()
      buildPath.modules = [ { isBuilt: true }, { isBuilt: true } ]
      expect(buildPath.isBuilt()).toEqual true
    

