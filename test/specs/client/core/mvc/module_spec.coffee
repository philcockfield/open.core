describe 'mvc/module', ->
  Module = null
  module = null
  
  beforeEach ->
      Module = core.mvc.Module
      module = new Module('modules/foo')
  
  it 'exists', ->
    expect(Module).toBeDefined()
  
  it 'extends core.Base', ->
    expect(module instanceof core.Base).toEqual true 
    
  it 'exposes the tryRequire utility method', ->
    expect(module.tryRequire).toEqual core.tryRequire
  
  it 'exposes the base require path', ->
    expect(module.modulePath).toEqual 'modules/foo'
  
  it 'support eventing', ->
    expect(-> module.bind 'name').not.toThrow()
  
  describe 'constructor', ->
    it 'calls super', ->
      ensure.parentConstructorWasCalled Module, -> new Module('modules/foo')
    
    it 'throw if a module path was not specified', ->
      expect(-> new Module()).toThrow()
      expect(-> new Module('')).toThrow()
      expect(-> new Module('   ')).toThrow()
    
    describe 'constructor property values', ->
      MyModule = null
      beforeEach ->
          class MyModule extends Module
            constructor: (properties) -> super 'path', properties
            defaults:
              text: null
      
      it 'assigns text property value', ->
        module = new MyModule text:'foo'
        expect(module.text()).toEqual 'foo'
      
      it 'does nothing if an empty object is passed to constructor', ->
        module = new MyModule {}
        expect(module.text()).toEqual null
      
      it 'does nothing if the property passed to the constructor does not exist as a property-function', ->
        expect(-> new MyModule foo:123).not.toThrow()
  
  
  describe 'convenience properties', ->
    it 'exposes the [core] library',     -> expect(module.core).toEqual core
    it 'exposes the [mvc] library',      -> expect(module.mvc).toEqual core.mvc
    it 'exposes the [controls] library', -> expect(module.controls).toEqual controls
  
  
  describe 'setting property functions with [defaults]', ->
    beforeEach ->
        class MyModule extends Module
          constructor: -> super 'path'
          defaults:
            text: null
            number: 123
        module = new MyModule()
    it 'has the text property', -> expect(module.text()).toEqual null
    it 'has the number property', -> expect(module.number()).toEqual 123
  
  
  describe '[require] mvc part methods', ->
    args = null
    beforeEach ->
        args = null
        spyOn(module, 'tryRequire').andCallFake (name, options) -> 
                args = { name:name, options:options }
        
    it 'pulls a require from the [model] folder', ->
      module.model 'bar'
      expect(args.name).toEqual 'modules/foo/models/bar'
      expect(args.options.throw).toEqual true
  
    it 'pulls a require from the [view] folder', ->
      module.view 'bar'
      expect(args.name).toEqual 'modules/foo/views/bar'
      expect(args.options.throw).toEqual true
  
    it 'pulls a require from the [controllers] folder', ->
      module.controller 'bar'
      expect(args.name).toEqual 'modules/foo/controllers/bar'
      expect(args.options.throw).toEqual true
    
    describe 'MVC part functions as object structure', ->
      it 'aliases the [model] method', ->
        expect(module.require.model).toEqual module.model
        
      it 'aliases the [view] method', ->
        expect(module.require.view).toEqual module.view

      it 'aliases the [controller] method', ->
        expect(module.require.controller).toEqual module.controller
    
    describe 'init-module pattern', ->
      module  = null
      beforeEach ->
          Module = require('core/test/modules/module4')
          module = new Module()
    
      it 'does not have an initialized [views] index yet', ->
        expect(module.views).not.toBeDefined()
      
      it 'initializes the required [MVC Part] with the [parent module]', ->
        myView = module.view 'my_view', init:true
        expect(myView.module).toEqual module

      it 'does not initialize the required [MVC Part] with the [parent module]', ->
        myView = module.view 'my_view', init:false
        expect(myView instanceof Function).toEqual true 

      it 'initializes the required [MVC Part] with the [parent module] by default', ->
        myView = module.view 'my_view'
        expect(myView.module).toEqual module
    
    describe 'storing module reference on MVC part function', ->
      it 'store modules on [model] require function', ->
        expect(module.model.module).toEqual module

      it 'store modules on [view] require function', ->
        expect(module.view.module).toEqual module

      it 'store modules on [controller] require function', ->
        expect(module.controller.module).toEqual module
    
    
  describe 'init() method', ->
    args = []
    beforeEach ->
        args = []
        spyOn(module, 'tryRequire').andCallFake (name, options) -> 
                args.push { name:name, options:options }
    
    it 'returns the module', ->
      expect(module.init()).toEqual module
    
    
    describe 'index (of MVC modules)', ->
      it 'indexes the [models] folder', ->
        module.init()
        expect(args[0].name).toEqual 'modules/foo/models/'
        expect(args[0].options.throw).toEqual false

      it 'indexes the [views] folder', ->
        module.init()
        expect(args[1].name).toEqual 'modules/foo/views/'
        expect(args[1].options.throw).toEqual false
    
      it 'indexes the [controllers] folder', ->
        module.init()
        expect(args[2].name).toEqual 'modules/foo/controllers/'
        expect(args[2].options.throw).toEqual false

    describe 'translation of [within] option to jQuery object', ->
      it 'does nothing if not [within] option was specified', ->
        options = {}
        module.init(options)
        expect(options.within).not.toBeDefined()
      
      it 'does nothing if [within] option is a jQuery object', ->
        body = $('body')
        options = within: body
        module.init(options)
        expect(options.within).toEqual body

      it 'translates a CSS selector [within] option to a jQuery object', ->
        options = within: 'body'
        module.init(options)
        expect(options.within).toEqual $('body')

      it 'translates a View [within] option to a jQuery object', ->
        view = new core.mvc.View(className:'foo')
        options = within: view
        module.init(options)
        expect(options.within).toEqual view.el

      it 'translates an HTML DOM element [within] option to a jQuery object', ->
        elBody = $('body').get(0)
        options = within: elBody
        module.init(options)
        expect(options.within).toEqual $(elBody)
      
  
  describe 'index of the MVC conventional structure (parts)', ->
    beforeEach ->
      spyOn(module, 'tryRequire').andCallFake (name, options) -> 
            return 'models_modules' if name is 'modules/foo/models/'
            return 'views_modules' if name is 'modules/foo/views/'
            return 'controllers_modules' if name is 'modules/foo/controllers/'
      
    describe 'calling index for each MVC folder', ->
      it 'stores the [models] index', ->
        module.init()
        expect(module.models).toEqual 'models_modules'

      it 'stores the [views] index', ->
        module.init()
        expect(module.views).toEqual 'views_modules'

      it 'stores the [controllers] index', ->
        module.init()
        expect(module.controllers).toEqual 'controllers_modules'
    
    describe 'getting the [index] of each MVC part via the static [requirePart] method', ->
      spyCalls = null
      beforeEach ->
        spyOn(Module, 'requirePart').andCallThrough()
        module.init()
        spyCalls = Module.requirePart.calls
      
      it 'calls [requirePart] for model', ->
        expect(spyCalls[0].args[0]).toEqual module.model

      it 'calls [requirePart] for view', ->
        expect(spyCalls[1].args[0]).toEqual module.view

      it 'calls [requirePart] for controller', ->
        expect(spyCalls[2].args[0]).toEqual module.controller
        
  
  describe 'no overwriting existing MVC properties set by the module', ->
    module = null
    beforeEach ->
        class MyModule extends Module
          constructor: -> 
              super 'core/test/modules/module1'
              @models      = 'models'
              @views       = 'views'
              @controllers = 'controllers'
        module = new MyModule()
        module.init()
    
    it 'does not overwrite [models] property', ->
      expect(module.models).toEqual 'models'
      
    it 'does not overwrite [views] property', ->
      expect(module.views).toEqual 'views'
      
    it 'does not overwrite [controllers] property', ->
      expect(module.controllers).toEqual 'controllers'
      
  
  describe '[requirePart] static method', ->
    it 'does not fail when the MVC part does not exist', ->
      spyOn(module, 'tryRequire').andCallThrough()
      expect(-> Module.requirePart(module.model)).not.toThrow()
      expect(module.tryRequire.mostRecentCall.args[1].throw).toEqual false

    it 'returns null if the MVC part does not exist', ->
      fnRequire = -> undefined
      result = Module.requirePart(fnRequire)
      expect(result).toEqual undefined
    
    it 'does nothing if the [index] is a simple object', ->
      spyOn(module, 'tryRequire').andCallFake (name, options) -> { foo:123 }
      expect(Module.requirePart(module.view).foo).toEqual 123
    
    it 'invokes the [index] as a function, passing in the [module] as the first argument', ->
      arg = null
      fnIndex = -> 
          return (m) -> arg = m
      fnIndex.module = module

      Module.requirePart(fnIndex)
      expect(arg).toEqual module
  
  describe 'module with no Models, Views or Controllers', ->
    describe 'with no sub-folders', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module1')
          module = new Module()
          module.init()

      it 'has empty [Models] object', ->
        expect(module.models).toEqual {}

      it 'has empty [Views] object', ->
        expect(module.views).toEqual {}

      it 'has empty [Controllers] object', ->
        expect(module.controllers).toEqual {}
    
    describe 'with sub-folders', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module2')
          module = new Module()
          module.init()

      it 'has empty [Models] object', ->
        expect(module.models).toEqual {}

      it 'has empty [Views] object', ->
        expect(module.views).toEqual {}

      it 'has empty [Controllers] object', ->
        expect(module.controllers).toEqual {}
  
  
  describe 'setting default [Views]', ->
    describe 'Module with [Index] and default [Views]', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module3')
          module = new Module()
          module.init()
          views = module.views
    
      it 'has a [views] index', ->
        expect(views).toBeDefined()
    
      it 'initializes the [views] index with the module', ->
        expect(views.module).toEqual module
    
      it 'has a [Root] view, initialized with the parent module', ->
        expect(views.Root).toBeDefined()
        expect(views.Root.module).toEqual module
    
      it 'has a [tmpl] object', ->
        Tmpl = views.Tmpl
        tmpl = new Tmpl
        expect(tmpl.root instanceof Function).toEqual true 
      
      it 'has a non-default [View] specified within the [Index]', ->
        expect(views.myView).toBeDefined()
        expect(views.myView.module).toEqual module
      
    
    describe 'Module with [Index] and no default [Views]', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module4')
          module = new Module()
          module.init()
          views = module.views
      
      it 'does not have any default views', ->
          expect(views.root).not.toBeDefined()
          expect(views.tmpl).not.toBeDefined()
      
      it 'has a non-default [View] specified within the [Index]', ->
        expect(views.myView).toBeDefined()
        expect(views.myView.module).toEqual module
    
    describe 'Module with no [Index] and default [Views]', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module5')
          module = new Module()
          module.init()
          views = module.views
      
      it 'has a [Root] view, initialized with the parent module', ->
        expect(views.Root).toBeDefined()
        expect(views.Root.module).toEqual module
      
      it 'has a [tmpl] object', ->
        Tmpl = views.Tmpl
        tmpl = new Tmpl
        expect(tmpl.root instanceof Function).toEqual true 

    describe 'Module with [Index] and default [Views], but default views setup by Index', ->
      module  = null
      views   = null
      beforeEach ->
          Module = require('core/test/modules/module6')
          module = new Module()
          module.init()
          views = module.views
      
      it 'does not overwrite a default [Root] view already setup by the [Index]', ->
        expect(views.Root).toEqual 'Root set in index'
      
      it 'does not overwrite a default [Tmpl] view already setup by the [Index]', ->
        expect(views.Tmpl).toEqual 'Tmpl set in index'



