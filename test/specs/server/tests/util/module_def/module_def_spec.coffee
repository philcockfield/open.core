TIMEOUT = 500

describe 'util/javascripts/module_def', ->
  SAMPLE_DIR  = "#{__dirname}/sample"
  SAMPLE_PATH = "#{SAMPLE_DIR}/module.json"
  ModuleDef   = null
  def         = null
  
  beforeEach ->
    ModuleDef = core.util.ModuleDef
    ModuleDef.reset()
    ModuleDef.defaults =
      includeRequireJS:    false
      header:              null
      minify:              true
      withDependencies:    true
      withLibs:            true
      includeRoot:         true
  
  it 'exists', -> expect(ModuleDef).toBeDefined()
  
  it 'throw if there is no name', ->
    expect(-> new ModuleDef("#{SAMPLE_DIR}/variants/no_name.json")).toThrow()
  
  
  describe 'loading', ->
    describe 'explicit file path', ->
      it 'loads from explicit file path', ->
        def = new ModuleDef "#{SAMPLE_DIR}/module.json"
        expect(def.path).toEqual SAMPLE_PATH
        expect(def.dir).toEqual SAMPLE_DIR
      
      it 'loads from explicit file path with white space', ->
        def = new ModuleDef "  #{SAMPLE_DIR}/module.json   "
        expect(def.path).toEqual SAMPLE_PATH
        expect(def.dir).toEqual SAMPLE_DIR
    
    describe 'directory path alternatives', ->
      it 'loads from clean dir path', ->
        expect(new ModuleDef("#{SAMPLE_DIR}").path).toEqual SAMPLE_PATH
        expect(def.dir).toEqual SAMPLE_DIR
      
      it 'loads from dir path ending in /', ->
        expect(new ModuleDef("#{SAMPLE_DIR}/").path).toEqual SAMPLE_PATH
        expect(def.dir).toEqual SAMPLE_DIR
      
      it 'loads from dir path ending in / with white space', ->
        expect(new ModuleDef("    #{SAMPLE_DIR}/   ").path).toEqual SAMPLE_PATH
        expect(def.dir).toEqual SAMPLE_DIR
  
  describe 'properties', ->
    beforeEach ->
      def = new ModuleDef SAMPLE_PATH
    
    it 'has a name', ->
      expect(def.name).toEqual 'sample'
    
    it 'has empty array of dependencies by default', ->
      expect(def.dependencies.length).toEqual 0
    
    describe 'file name', ->
      it 'has the [name] as the file name (not specified)', ->
        expect(def.file).toEqual 'sample'
      
      it 'has an explicit file name', ->
        def = new ModuleDef "#{SAMPLE_DIR}/variants/file_name.json"
        expect(def.name).toEqual 'foo'
        expect(def.file).toEqual 'foo-bar'
  
  describe 'dependencies', ->
    DIR = "#{SAMPLE_DIR}/collection/folder"
    
    it 'has one layer of dependencies [resolve() method]', ->
      ModuleDef.registerPath DIR
      def  = new ModuleDef DIR
      deps = def.dependencies.resolve()
      expect(deps.length).toEqual 2
      expect(deps[0]).toEqual ModuleDef.find('ns/child1')
      expect(deps[1]).toEqual ModuleDef.find('ns/child2')
    
    it 'has two layers of dependencies [resolve().all property]', ->
      ModuleDef.registerPath DIR
      
      def = new ModuleDef "#{SAMPLE_DIR}/variants/with_dependencies.json"
      deps = def.dependencies.resolve()
      all = deps.all
      
      expect(all.length).toEqual 3
      expect(all[0].name).toEqual 'ns/child1'
      expect(all[1].name).toEqual 'ns/child2'
      expect(all[2].name).toEqual 'ns/folder'
    
    it 'throws if dependency is not registered', ->
      new ModuleDef DIR
      expect(-> def.dependencies.resolve()).toThrow()
    
    it 'does not include any self-references', ->
      path = "#{SAMPLE_DIR}/variants/self_reference"
      ModuleDef.registerPath path
      
      def = new ModuleDef path
      deps = def.dependencies.resolve()
      expect(deps.length).toEqual 0
  
  
  describe '_builder() method', ->
    DIR = "#{SAMPLE_DIR}/variants"
    beforeEach ->
      ModuleDef.registerPath "#{SAMPLE_DIR}/collection/folder"
    
    describe 'Builder options', ->
      it 'uses explicitly passed in Builder options', ->
        builder = new ModuleDef(SAMPLE_DIR)._toBuilder
          includeRequireJS: true
          header: 'copyright foo'
          minify: false
        
        expect(builder.includeRequireJS).toEqual true
        expect(builder.header).toEqual 'copyright foo'
        expect(builder.minify).toEqual false
      
      it 'uses default Builder option defaults', ->
        builder = new ModuleDef(SAMPLE_DIR)._toBuilder()
        expect(builder.includeRequireJS).toEqual false
        expect(builder.header).toEqual null
        expect(builder.minify).toEqual true
      
      it 'uses updated Builder options defaults', ->
        ModuleDef.defaults =
          includeRequireJS:     true
          header:               'Foo!'
          minify:               false
        
        builder = new ModuleDef(SAMPLE_DIR)._toBuilder()
        expect(builder.includeRequireJS).toEqual true
        expect(builder.header).toEqual 'Foo!'
        expect(builder.minify).toEqual false
        expect(builder.paths.length).toEqual 0
    
    it 'has a single path', ->
      builder = new ModuleDef("#{DIR}/simple.json")._toBuilder()
      expect(builder.paths[0].path).toEqual DIR
      expect(builder.paths[0].namespace).toEqual 'ns'
    
    it 'has dependent paths', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def._toBuilder()
      paths   = builder.paths
      
      expect(paths.length).toEqual 3
      expect(paths[0].namespace).toEqual 'ns/child1'
      expect(paths[1].namespace).toEqual 'ns/child2'
      expect(paths[2].namespace).toEqual 'ns/folder'

    it 'excludes dependent paths with flag', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def._toBuilder withDependencies:false
      paths   = builder.paths
      expect(paths.length).toEqual 1
      expect(paths[0].namespace).toEqual 'ns/folder'
    
    it 'includes dependent paths excludes the root module with flag', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def._toBuilder includeRoot:false
      paths   = builder.paths
      expect(paths.length).toEqual 2
      expect(paths[0].namespace).toEqual 'ns/child1'
      expect(paths[1].namespace).toEqual 'ns/child2'

    it 'includes no paths', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def._toBuilder includeRoot:false, withDependencies:false
      paths   = builder.paths
      expect(paths.length).toEqual 0
  
  describe 'libs', ->
    beforeEach ->
      ModuleDef.registerPath "#{SAMPLE_DIR}/libs"
    
    it 'has an empty libs array', ->
      def = new ModuleDef(SAMPLE_DIR)
      expect(def.libs).toEqual []
    
    it 'converts lib paths into objects', ->
      def  = ModuleDef.find 'libs-sample'
      libs = def.libs
      expect(libs[0].path).toEqual "#{def.dir}/file1.js"
      expect(libs[1].path).toEqual "#{def.dir}/libs/file2.js"
      expect(libs[2].path).toEqual "#{def.dir}/libs/file3.js"
    
    it 'extracts titles', ->
      def  = ModuleDef.find 'libs-sample'
      libs = def.libs
      expect(libs[0].title).toEqual 'file1.js'
      expect(libs[1].title).toEqual 'file2.js'
      expect(libs[2].title).toEqual 'My Title'
  
  
  describe 'build() method', ->
    def = null
    beforeEach ->
      ModuleDef.registerPath "#{SAMPLE_DIR}/libs"
      ModuleDef.registerPath "#{SAMPLE_DIR}/simple"
      def  = ModuleDef.find 'libs-sample'
    
    
    it 'builds with libs', ->
      code = null
      waitsFor (-> code?), TIMEOUT
      
      def.build withLibs:true, (c) -> code = c
      runs -> 
        code = code.standard
        
        # Has the module file.
        expect(_(code).include('var file1 = 123')).toEqual true
        
        # Has not compiled the lib files into Common-JS modules.
        expect(_(code).include('"libs-sample/file1": function')).toEqual false
        expect(_(code).include('"libs-sample/libs/file2": function')).toEqual false
        expect(_(code).include('"libs-sample/libs/file3": function')).toEqual false
      
    it 'builds without libs', ->
      code = null
      waitsFor (-> code?), TIMEOUT
      
      def.build withLibs:false, (c) -> code = c
      runs -> 
        code = code.standard
        
        libsHeader = '''
                      /* 
                        - file1.js
                        - file2.js
                        - file3.js
                      */
                     '''
        expect(_(code).include(libsHeader)).toEqual false

  
  describe 'static methods', ->
    DIR = "#{SAMPLE_DIR}/collection"
    
    describe 'modules collection', ->
      it 'has a [modules] collection', ->
        expect(ModuleDef.modules).toEqual []
      
      it 'finds all modules within a folder', ->
        ModuleDef.registerPath "#{DIR}/folder"
        expect(ModuleDef.modules.length).toEqual 3
      
      it 'does not register the sample folder twice', ->
        ModuleDef.registerPath "#{DIR}/folder"
        ModuleDef.registerPath "#{DIR}/folder"
        expect(ModuleDef.modules.length).toEqual 3
      
      it 'throws if there are duplicate namespace declarations', ->
        expect(-> ModuleDef.registerPath DIR).toThrow()
    
    describe 'find()', ->
      beforeEach -> ModuleDef.registerPath "#{DIR}/folder"
      it 'finds modules', ->
        expect(ModuleDef.find('ns/folder')).toEqual ModuleDef.modules[0]
        expect(ModuleDef.find('ns/child1')).toEqual ModuleDef.modules[1]
      
      it 'does not find a non-existent module', ->
        expect(ModuleDef.find('foo')).toEqual null
        expect(ModuleDef.find('')).toEqual null
        expect(ModuleDef.find()).toEqual null
  
      it 'does not find the module when the collection is empty', ->
        ModuleDef.reset()
        expect(ModuleDef.find('foo')).toEqual null
      
