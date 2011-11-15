describe 'core/util/conversion', ->
  
  describe 'safeHtml()', ->
    it 'converts to safe HTML', ->
        html = "<div>Foo</div>"
        expect(core.util.toSafeHtml(html)).toEqual '&lt;div&gt;Foo&lt;/div&gt;'
    
    it 'returns null', ->
      expect(core.util.toSafeHtml()).toEqual null
    
    
  