fs     = require 'fs'
fsUtil = core.util.fs


describe 'util/package/private_package', ->
  SAMPLE_DIR      = "#{__dirname}/sample"
  MODULES_DIR     = "#{SAMPLE_DIR}/node_modules.private"
  SAMPLE_PACKAGE  = "#{SAMPLE_DIR}/package.private.json"
  EMPTY_PACKAGE   = "#{SAMPLE_DIR}/package_empty.private.json"
  
  
  PrivatePackage  = null
  package         = null
  beforeEach ->
    PrivatePackage  = core.util.PrivatePackage
    package         = new PrivatePackage SAMPLE_DIR
    package.linkDir = "#{SAMPLE_DIR}/global_modules"
    core.log.silent = true
  
  afterEach ->
    fsUtil.deleteSync "#{SAMPLE_DIR}/node_modules.private", force:true
     
  
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
  
  describe 'dependencies property', ->
    it 'has two dependencies', ->
      expect(package.dependencies.length).toEqual 2
    
    it 'has empty dependencies array when nothing is specified in JSON', ->
      package = new PrivatePackage EMPTY_PACKAGE
      expect(package.dependencies.length).toEqual 0
  
  
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
    
    it 'deletes an existing real directory', ->
      fsUtil.deleteSync "#{SAMPLE_DIR}/node_modules.private", force:true
      fsUtil.createDirSync "#{MODULES_DIR}/module1"
      package.link()
      lstat = fs.lstatSync("#{MODULES_DIR}/module1")
      expect(lstat.isSymbolicLink()).toEqual true, 'Is a symbolic link'
    
    it 'does nothing when there are no dependencies', ->
      package = new PrivatePackage EMPTY_PACKAGE
      package.link()
      expect(fsUtil.existsSync(MODULES_DIR)).toEqual false
  
  describe 'unlink() method', ->
    it 'removes the symbolic link', ->
      package.link()
      package.unlink()
      expect(fsUtil.existsSync("#{MODULES_DIR}/module1")).toEqual false
    
    it 'does not remove a real directory', ->
      fsUtil.deleteSync "#{SAMPLE_DIR}/node_modules.private", force:true
      fsUtil.createDirSync "#{MODULES_DIR}/module1"
      package.unlink()
      expect(fsUtil.existsSync("#{MODULES_DIR}/module1")).toEqual true
    
    it 'does nothing when there are no dependencies', ->
      package = new PrivatePackage EMPTY_PACKAGE
      package.link()
      package.unlink()
      expect(fsUtil.existsSync(MODULES_DIR)).toEqual false
  
  
  describe 'clear() method', ->
    it 'clears the private modules folder', ->
      package.link()
      expect(fsUtil.readDirSync(MODULES_DIR).length).not.toEqual 0, 'Has contents'
      package.clear()
      expect(fsUtil.readDirSync(MODULES_DIR).length).toEqual 0, 'Empty'
      
      
      
    
    
    
    
  
    
    
