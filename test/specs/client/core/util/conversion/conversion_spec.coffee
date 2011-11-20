describe 'core/util/conversion', ->
  
  describe 'escaping HTML', ->
    html    = """<div>Foo & " ' </div>"""
    escaped = '&lt;div&gt;Foo &amp; &quot; &#39; &lt;/div&gt;'
  
    describe 'escapeHtml', ->
      it 'returns null', -> expect(core.util.escapeHtml()).toEqual null
      it 'converts to escaped HTML', ->
          expect(core.util.escapeHtml(html)).toEqual '&lt;div&gt;Foo &amp; &quot; &#39; &lt;/div&gt;'

    describe 'unescapeHtml', ->
      it 'returns null', -> expect(core.util.unescapeHtml()).toEqual null
      it 'converts escaped string HTML', ->
          expect(core.util.unescapeHtml(escaped)).toEqual html
    
    
    
  