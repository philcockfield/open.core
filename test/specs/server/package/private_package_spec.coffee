fs     = require 'fs'
fsUtil = core.util.fs


describe 'util/package/private_package', ->
  SAMPLE_DIR      = "#{__dirname}/sample"
  MODULES_DIR     = "#{SAMPLE_DIR}/node_modules.private"
  SAMPLE_PACKAGE  = "#{SAMPLE_DIR}/package.private.json"
  
  
  PrivatePackage  = null
  package         = null
  beforeEach ->
    PrivatePackage  = core.util.PrivatePackage
    package         = new PrivatePackage SAMPLE_DIR
    package.linkDir = "#{SAMPLE_DIR}/global_modules"
  
  afterEach ->
    # fsUtil.deleteSync "#{SAMPLE_DIR}/node_modules.private", force:true
     
  
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
    path = package.linkDir
    expect(fs.statSync(path).isDirectory()).toEqual true
  
  
  describe 'link() method', ->
    it 'creates the private node_modules folder', ->
      package.link()
      expect(fsUtil.existsSync(MODULES_DIR)).toEqual true
    
    it 'contains a sym-link to [module1]', ->
      package.link()
      lstat = fs.lstatSync("#{MODULES_DIR}/module1")
      expect(lstat.isSymbolicLink()).toEqual true, 'Is a symbolic link'
    
    it 'does nothing if the source link does not exist', ->
      expect(fsUtil.existsSync("#{MODULES_DIR}/fake")).toEqual false
    
    it 'deletes an existing directory', ->
      fsUtil.deleteSync "#{SAMPLE_DIR}/node_modules.private", force:true
      fsUtil.createDirSync "#{MODULES_DIR}/module1"
      package.link()
      lstat = fs.lstatSync("#{MODULES_DIR}/module1")
      expect(lstat.isSymbolicLink()).toEqual true, 'Is not a symbolic link'
      
      
    
    
      
    
    
    
  
  
  
  
  