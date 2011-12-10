fs = require 'fs'

describe 'server/util/json_file', ->
  SAMPLE_DIR = "#{__dirname}/sample"
  SAMPLE_FOO = "#{SAMPLE_DIR}/foo.json"
  
  JsonFile = null
  json     = null
  
  beforeEach ->
    JsonFile = core.util.JsonFile
    json     = new JsonFile SAMPLE_FOO
  
  it 'exists', -> expect(JsonFile).toBeDefined()
  
  describe 'constructor', ->
    it 'passes the path and file-name through the [formatPath] method', ->
      spyOn(JsonFile, 'formatPath').andCallFake (args) -> 
        result =
          path: SAMPLE_FOO
          dir:  SAMPLE_DIR
      json = new JsonFile '/foo/', 'bar.json'
      args = JsonFile.formatPath.mostRecentCall.args
      expect(args[0]).toEqual '/foo/'
      expect(args[1]).toEqual 'bar.json'
    
    it 'stores the path as a property', ->
      expect(json.path).toEqual SAMPLE_FOO
    
    it 'stores the directory as a property', ->
      expect(json.dir).toEqual SAMPLE_DIR
    
    it 'loads the JSON data from file', ->
      data = fs.readFileSync SAMPLE_FOO, 'utf8'
      data = JSON.parse data.toString()
      data = JSON.stringify data
      expect(JSON.stringify(json.data)).toEqual data
      
    it 'throws an error if the file cannot be loaded', ->
      expect(-> json = new JsonFile '/foo/').toThrow()
      
    it ' throw an error if the JSON cannot be parsed', ->
      expect(-> json = new JsonFile("#{SAMPLE_DIR}/invalid.json")).toThrow()
  
  
  describe 'formatPath() method [static]', ->
    describe 'no default file-name', ->
      it 'throws if now path was specified', ->
        expect(-> JsonFile.formatPath()).toThrow()
      
      it 'returns the trimmed path', ->
        expect(JsonFile.formatPath('  /foo/bar.json   ').path).toEqual '/foo/bar.json'
        
      it 'returns the trimmed directory', ->
        expect(JsonFile.formatPath('  /foo/baz///bar.json   ').dir).toEqual '/foo/baz'
      
      it 'has no directory (from root)', ->
        expect(JsonFile.formatPath('  /bar.json   ').path).toEqual '/bar.json'
        expect(JsonFile.formatPath('  /bar.json   ').dir).toEqual null
        
      it 'has no directory (just file name)', ->
        expect(JsonFile.formatPath('  bar.json   ').path).toEqual 'bar.json'
        expect(JsonFile.formatPath('  bar.json   ').dir).toEqual null
    
    describe 'with a default file-name', ->
      it 'returns the explicit path if a .json file is specified', ->
        expect(JsonFile.formatPath('/foo/bar.json', 'package.json').path).toEqual '/foo/bar.json'
      
      it 'returns the default file only', ->
        result = JsonFile.formatPath('   ', 'package.json')
        expect(result.path).toEqual 'package.json'
        expect(result.dir).toEqual null
      
      it 'returns the [dir + file-name]', ->
        result = JsonFile.formatPath('/foo/bar/', 'package.json')
        expect(result.path).toEqual '/foo/bar/package.json'
        expect(result.dir).toEqual '/foo/bar'
      
      it 'returns the [dir + file-name] with  white space', ->
        result = JsonFile.formatPath('   /foo/bar/  ', '  package.json   ')
        expect(result.path).toEqual '/foo/bar/package.json'
        expect(result.dir).toEqual '/foo/bar'
      
      it 'strips leading / from file-name', ->
        result = JsonFile.formatPath('/foo/bar/', '///package.json')
        expect(result.path).toEqual '/foo/bar/package.json'
      
      
  describe 'saveSync() method', ->
    it 'passes execution to the [writeFileSync] method', ->
      data = fs.readFileSync SAMPLE_FOO, 'utf8'
      data = JSON.parse data.toString()
      data = JSON.stringify data, null, '\t'
      
      path = null
      data = null
      spyOn(fs, 'writeFileSync').andCallFake (p, d) -> 
        path = p
        data = d
      
      json.saveSync()
      expect(fs.writeFileSync.callCount).toEqual 1
      expect(path).toEqual json.path
      expect(data).toEqual data
      
