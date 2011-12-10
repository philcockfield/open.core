fs = require 'fs'

describe 'util/package/package', ->
  SAMPLE_DIR      = "#{__dirname}/sample"
  SAMPLE_PACKAGE  = "#{SAMPLE_DIR}/package.json"
  Package         = null
  package         = null
  
  beforeEach ->
    Package = core.util.Package
    package = new Package SAMPLE_DIR
  
  it 'exists', ->
    expect(Package).toBeDefined()
  
  it 'is a [JsonFile]', ->
    expect(package instanceof core.util.JsonFile).toEqual true 
  
  describe 'paths', ->
    it 'loads the package from a directory path', ->
      expect(package.path).toEqual "#{SAMPLE_DIR}/package.json"
    
    it 'stores the directory path', ->
      expect(package.dir).toEqual SAMPLE_DIR

    it 'loads the JSON data from file', ->
      data = fs.readFileSync SAMPLE_PACKAGE, 'utf8'
      data = JSON.parse data.toString()
      data = JSON.stringify data
      expect(JSON.stringify(package.data)).toEqual data
    
    
  
  
  
    
    
    
    
  
  
  
  