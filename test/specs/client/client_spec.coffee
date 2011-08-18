describe 'client', ->
  it 'exists', ->
    expect(require('open.client/core')).toBeDefined()
  
  describe 'index properties', ->
    it 'has title', ->
      expect(_.isString(core.title)).toEqual true
    
    it 'has Base', ->
      expect(core.Base).toEqual require 'open.client/core/base'
    
    it 'has MVC', ->
      expect(core.mvc).toEqual require 'open.client/core/mvc'
    
    it 'has util', ->
      expect(core.util).toEqual require 'open.client/core/util'
      
      
    
    
  describe 'tryRequire', ->
    beforeEach ->
        spyOn(window, 'require').andCallThrough()
        spyOn(console, 'log')
    
    it 'retreives an existing module', ->
      m = core.tryRequire 'open.client/core'
      expect(m).toEqual core
    
    it 'calls require for unknown (and does not throw)', ->
      core.tryRequire 'Foo'
      expect(window.require).toHaveBeenCalled()
    
    it 'calls require for unknown (and does throw)', ->
      expect(-> core.tryRequire('Foo', throw:true)).toThrow()

    it 'does not los message to console for unknown module (by default)', ->
      core.tryRequire 'Foo'
      expect(console.log).not.toHaveBeenCalled()
    
    it 'logs message to console for unknown module', ->
      core.tryRequire 'Foo', log:true
      expect(console.log).toHaveBeenCalled()
    
    
        
        
    