describe 'util', ->
  describe 'tryRequire', ->
    tryRequire = null
    beforeEach ->
        tryRequire = core.util.tryRequire
        spyOn(window, 'require').andCallThrough()
        spyOn(console, 'log')
  
    it 'retreives an existing module', ->
      m = tryRequire 'open.client/core'
      expect(m).toEqual core
  
    it 'calls require for unknown (and does not throw)', ->
      tryRequire 'Foo'
      expect(window.require).toHaveBeenCalled()
  
    it 'calls require for unknown (and does throw)', ->
      expect(-> tryRequire('Foo', throw:true)).toThrow()

    it 'does not los message to console for unknown module (by default)', ->
      tryRequire 'Foo'
      expect(console.log).not.toHaveBeenCalled()
  
    it 'logs message to console for unknown module', ->
      tryRequire 'Foo', log:true
      expect(console.log).toHaveBeenCalled()
  
  


