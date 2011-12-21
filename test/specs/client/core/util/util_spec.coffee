describe 'util', ->
  View = null
  util = null
  beforeEach -> 
    View = core.mvc.View
    util = core.util
  
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
  
  
  describe 'formatLinks()', ->
    html = """
           <div>
            <a>0</a>
            <a href="/foo">1</a>
            <a href="http://foo">2</a>
            <a href="http://foo.com" target="_blank">3</a>
            <a href="http://foo.com" target="_self">4</a>
            <a href="https://foo.com">5</a>
            <a href="hTtp://foo" class="core_external">6</a>
            <a href="/bar" target="_self">7</a>
            <a href="mailto:bob@domain.com">8</a>
           </div>    
           """
    div = null
    a0  = null
    a1  = null
    a2  = null
    a3  = null
    a4  = null
    a5  = null
    a6  = null
    a7  = null
    a8  = null
    beforeEach ->
      div = $ html
      core.util.formatLinks div
      children = div.children()
      a0 = $ children[0]
      a1 = $ children[1]
      a2 = $ children[2]
      a3 = $ children[3]
      a4 = $ children[4]
      a5 = $ children[5]
      a6 = $ children[6]
      a7 = $ children[7]
      a8 = $ children[8]
    
    it 'does nothing if no element is passed', ->
      core.util.formatLinks()
    
    it 'does nothing to an anchor with no href', ->
      expect(a0.hasClass('core_external')).toEqual false
      expect(a0.attr('target')).toEqual null
    
    it 'does not add the CSS class to an internal link', ->
      expect(a1.hasClass('core_external')).toEqual false
      expect(a7.hasClass('core_external')).toEqual false
    
    it 'adds the CSS class to external links', ->
      expect(a2.hasClass('core_external')).toEqual true
      expect(a3.hasClass('core_external')).toEqual true
      expect(a4.hasClass('core_external')).toEqual true
      expect(a5.hasClass('core_external')).toEqual true
      expect(a8.hasClass('core_external')).toEqual true
    
    it 'sets a custom CSS class name', ->
      core.util.formatLinks div, className:'foo_external'
      expect(a2.hasClass('foo_external')).toEqual true
    
    it 'sets the target to [_blank] for external links', ->
      expect(a2.attr('target')).toEqual '_blank'
      expect(a3.attr('target')).toEqual '_blank'
      expect(a4.attr('target')).toEqual '_blank'
      expect(a5.attr('target')).toEqual '_blank'
      expect(a6.attr('target')).toEqual '_blank'
    
    it 'sets the target to [_self] for external links', ->
      core.util.formatLinks div, target:'_self'
      expect(a2.attr('target')).toEqual '_self'
    
    it 'does not change the target for internal links', ->
      expect(a0.attr('target')).toEqual null
      expect(a1.attr('target')).toEqual null
      expect(a7.attr('target')).toEqual '_self'
  
    it 'does not set the target for [mailto:] links', ->
      expect(a8.attr('target')).toEqual null
    
  
  describe 'scrollClasses', ->
    div = null
    beforeEach ->
      div = $ '<div></div>'
    
    it 'does nothing if null is passed', ->
      util.syncScroll()
      expect(View.outerHtml(div)).toEqual '<div></div>'
    
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
    
