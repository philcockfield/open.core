describe 'core/index', ->
  it 'exists', ->
    expect(require('open.client/core')).toBeDefined()
  
  describe 'default core index properties', ->
    it 'has title', ->
      expect(_.isString(core.title)).toEqual true
    
    it 'has Base', ->
      expect(core.Base).toEqual require 'open.client/core/base'
    
    it 'has MVC', ->
      expect(core.mvc).toEqual require 'open.client/core/mvc'
    
    it 'has util', ->
      expect(core.util).toEqual require 'open.client/core/util'
      
    it 'has tryRequire', -> 
      expect(core.tryRequire).toBeDefined()
      expect(core.tryRequire).toEqual core.util.tryRequire
    
  describe 'init()', ->
    beforeEach ->
        core.init()
    
    it 'has controls after initialization', ->
      expect(core.controls).toEqual require 'open.client/controls'
    