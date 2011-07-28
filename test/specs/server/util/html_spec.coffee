describe 'server/util/html', ->
  html = core.util.html
  describe 'preventCache', ->
    it 'prevents caching when in development mode', ->
      expect(html.preventCache()).toEqual true

    it 'allows caching when in production mode', ->
      core.app.settings.env = 'production'
      expect(html.preventCache()).toEqual false

    it 'allows caching in development mode (override)', ->
      expect(html.preventCache(preventCache:false)).toEqual false

    it 'prevents caching in production mode (override)', ->
      core.app.settings.env = 'production'
      expect(html.preventCache(preventCache:true)).toEqual true

  describe 'script', ->
    qs = '?uid'
    beforeEach ->
        core.app.settings.env = 'development'
        spyOn(_, 'uniqueUrl').andCallFake (url) -> url + qs

    it 'produces a <script> with the exact url (when in production)', ->
      core.app.settings.env = 'production'
      script = html.script('foo.js')
      expect(script).toEqual '<script src="foo.js" type="text/javascript"></script>'

    it 'produces a <script> with a unique url', ->
      script = html.script('foo.js')
      expect(script).toEqual '<script src="foo.js?uid" type="text/javascript"></script>'
      
    