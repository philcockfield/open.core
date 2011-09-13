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
  
  it 'calls super', ->
    ensure.parentConstructorWasCalled Module, -> new Module()
    
  it 'exposes the tryRequire utility method', ->
    expect(module.tryRequire).toEqual core.tryRequire
  
  it 'exposes the base require path', ->
    expect(module.modulePath).toEqual 'modules/foo'
  
  
  describe '[require] mvc part methods', ->
    args = null
    beforeEach ->
        args = null
        spyOn(module, 'tryRequire').andCallFake (name, options) -> 
                args = { name:name, options:options }
        
    it 'pulls a require from the [model] folder', ->
      module.require.model 'bar'
      expect(args.name).toEqual 'modules/foo/models/bar'
      expect(args.options.throw).toEqual true
  
    it 'pulls a require from the [view] folder', ->
      module.require.view 'bar'
      expect(args.name).toEqual 'modules/foo/views/bar'
      expect(args.options.throw).toEqual true
  
    it 'pulls a require from the [controllers] folder', ->
      module.require.controller 'bar'
      expect(args.name).toEqual 'modules/foo/controllers/bar'
      expect(args.options.throw).toEqual true
    
    describe 'storing module reference on MVC part function', ->
      it 'store modules on [model] require function', ->
        expect(module.require.model.module).toEqual module

      it 'store modules on [view] require function', ->
        expect(module.require.view.module).toEqual module

      it 'store modules on [controller] require function', ->
        expect(module.require.controller.module).toEqual module
    
    
  describe 'init', ->
    args = []
    beforeEach ->
        args = []
        spyOn(module, 'tryRequire').andCallFake (name, options) -> 
                args.push { name:name, options:options }
    
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
      
  
  describe 'index (the MVC conventional structure)', ->
    beforeEach ->
      spyOn(module, 'tryRequire').andCallFake (name, options) -> 
            return 'models_modules' if name is 'modules/foo/models/'
            return 'views_modules' if name is 'modules/foo/views/'
            return 'controllers_modules' if name is 'modules/foo/controllers/'

    describe 'calling index for each MVC folder', ->
      it 'stores the [models] index', ->
        module.init()
        expect(module.index.models).toEqual 'models_modules'

      it 'stores the [views] index', ->
        module.init()
        expect(module.index.views).toEqual 'views_modules'

      it 'stores the [controllers] index', ->
        module.init()
        expect(module.index.controllers).toEqual 'controllers_modules'
    












