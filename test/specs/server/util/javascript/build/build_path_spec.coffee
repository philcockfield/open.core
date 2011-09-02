describe 'util/javascript/build/build_path', ->
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
        
      it 'is a coffee-script file', ->
        buildPath = new BuildPath source:'/foo/bar.coffee'
        expect(buildPath.isJavascript).toEqual false
        expect(buildPath.isCoffee).toEqual true
        expect(buildPath.isFolder).toEqual false
        
      it 'is a folder file', ->
        buildPath = new BuildPath source:'/foo/bar'
        expect(buildPath.isJavascript).toEqual false
        expect(buildPath.isCoffee).toEqual false
        expect(buildPath.isFolder).toEqual true
        
      
    
        
      
        
  