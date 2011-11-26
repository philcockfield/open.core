describe 'util/javascripts/module_definition', ->
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
      includeDependencies: true
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
  
  
  describe 'builder() method', ->
    DIR = "#{SAMPLE_DIR}/variants"
    beforeEach ->
      ModuleDef.registerPath "#{SAMPLE_DIR}/collection/folder"
    
    describe 'Builder options', ->
      it 'uses explicitly passed in Builder options', ->
        builder = new ModuleDef(SAMPLE_DIR).builder
          includeRequireJS: true
          header: 'copyright foo'
          minify: false
        
        expect(builder.includeRequireJS).toEqual true
        expect(builder.header).toEqual 'copyright foo'
        expect(builder.minify).toEqual false
      
      it 'uses default Builder option defaults', ->
        builder = new ModuleDef(SAMPLE_DIR).builder()
        expect(builder.includeRequireJS).toEqual false
        expect(builder.header).toEqual null
        expect(builder.minify).toEqual true
      
      it 'uses updated Builder options defaults', ->
        ModuleDef.defaults =
          includeRequireJS:     true
          header:               'Foo!'
          minify:               false
          includeDependencies:  false
          includeRoot:          false
        
        builder = new ModuleDef(SAMPLE_DIR).builder()
        expect(builder.includeRequireJS).toEqual true
        expect(builder.header).toEqual 'Foo!'
        expect(builder.minify).toEqual false
        expect(builder.paths.length).toEqual 0
    
    
    it 'has a single path', ->
      builder = new ModuleDef("#{DIR}/simple.json").builder()
      expect(builder.paths[0].path).toEqual DIR
      expect(builder.paths[0].namespace).toEqual 'ns'
    
    it 'has dependent paths', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def.builder()
      paths   = builder.paths
      
      expect(paths.length).toEqual 3
      expect(paths[0].namespace).toEqual 'ns/child1'
      expect(paths[1].namespace).toEqual 'ns/child2'
      expect(paths[2].namespace).toEqual 'ns/folder'

    it 'excludes dependent paths with flag', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def.builder includeDependencies:false
      paths   = builder.paths
      expect(paths.length).toEqual 1
      expect(paths[0].namespace).toEqual 'ns/folder'
    
    it 'includes dependent paths excludes the root module with flag', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def.builder includeRoot:false
      paths   = builder.paths
      expect(paths.length).toEqual 2
      expect(paths[0].namespace).toEqual 'ns/child1'
      expect(paths[1].namespace).toEqual 'ns/child2'

    it 'includes no paths', ->
      def     = ModuleDef.find 'ns/folder'
      builder = def.builder includeRoot:false, includeDependencies:false
      paths   = builder.paths
      expect(paths.length).toEqual 0
  
  
  describe 'save', ->
    it 'saves to the given directory and the module file name', ->
      def = new ModuleDef SAMPLE_PATH
      
      fakeBuilder =
        save: (options, callback) -> 
          @options  = options
          @callback = callback
      spyOn(def, 'builder').andCallFake (args) -> fakeBuilder
      
      fn = -> 
      def.save '/dir', header:'abc', fn
      expect(fakeBuilder.options.dir).toEqual '/dir'
      expect(fakeBuilder.options.name).toEqual def.file
      expect(fakeBuilder.callback).toEqual fn
  
  
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
      
