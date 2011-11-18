describe 'util', ->
  util = null
  beforeEach -> util = core.util
  
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
  
  
  describe 'scrollClasses', ->
    div = null
    beforeEach ->
      div = $ '<div></div>'
    
    it 'does nothing if null is passed', ->
      util.syncScroll()
      expect(div[0].outerHTML).toEqual '<div></div>'
    
    it 'returns the element', ->
      expect(util.syncScroll(div)).toEqual div
    
    it 'adds the [x] class', ->
      util.syncScroll div, 'x'
      expect(div.hasClass('core_scroll_x')).toEqual    true
      expect(div.hasClass('core_scroll_y')).toEqual    false
      expect(div.hasClass('core_scroll_xy')).toEqual   false
      expect(div.hasClass('core_scroll_none')).toEqual false
    
    it 'adds the [y] class', ->
      util.syncScroll div, 'y'
      expect(div.hasClass('core_scroll_x')).toEqual    false
      expect(div.hasClass('core_scroll_y')).toEqual    true
      expect(div.hasClass('core_scroll_xy')).toEqual   false
      expect(div.hasClass('core_scroll_none')).toEqual false
    
    it 'adds the [xy] class', ->
      util.syncScroll div, 'xy'
      expect(div.hasClass('core_scroll_x')).toEqual    false
      expect(div.hasClass('core_scroll_y')).toEqual    false
      expect(div.hasClass('core_scroll_xy')).toEqual   true
      expect(div.hasClass('core_scroll_none')).toEqual false
    
    it 'adds the [none] class', ->
      util.syncScroll div, null
      expect(div.hasClass('core_scroll_x')).toEqual    false
      expect(div.hasClass('core_scroll_y')).toEqual    false
      expect(div.hasClass('core_scroll_xy')).toEqual   false
      expect(div.hasClass('core_scroll_none')).toEqual true
    
    it 'defaults to [y]', ->
      util.syncScroll div
      expect(div.hasClass('core_scroll_y')).toEqual true
    
    it 'uses a custom CSS prefix', ->
      util.syncScroll div, 'xy', prefix:'foo_'
      expect(div.hasClass('foo_xy')).toEqual true
    
    it 'trims the axis value', ->
      util.syncScroll div, '   y    '
      expect(div.hasClass('core_scroll_y')).toEqual true
    
