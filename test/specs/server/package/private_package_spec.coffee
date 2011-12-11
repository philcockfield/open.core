fs     = require 'fs'


describe 'util/package/private_package', ->
  SAMPLE_DIR      = "#{__dirname}/sample"
  SAMPLE_PACKAGE  = "#{SAMPLE_DIR}/package.private.json"
  
  PrivatePackage  = null
  package         = null
  beforeEach ->
    PrivatePackage = core.util.PrivatePackage
    package        = new PrivatePackage SAMPLE_DIR
  
  it 'exists', ->
    expect(PrivatePackage).toBeDefined()
  
  it 'is a [JsonFile]', ->
    expect(package instanceof core.util.JsonFile).toEqual true 
  
  it 'loads the private package', ->
    data = fs.readFileSync SAMPLE_PACKAGE, 'utf8'
    data = JSON.parse data.toString()
    data = JSON.stringify data
    expect(JSON.stringify(package.data)).toEqual data
  
  
  it 'has a reference to the node libs folder', ->
    expect(_(package.linkDir).endsWith('node/lib/node_modules')).toEqual true
    
  
  
  
  