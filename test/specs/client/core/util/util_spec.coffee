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
  
  
  describe 'conversion', ->
    describe 'toBool', ->
      toBool = null
      beforeEach -> toBool = core.util.toBool

      describe 'invalid', ->
        it 'converts object to null', ->
          expect(toBool({ foo:123 })).toEqual null

      describe 'no value', ->
        it 'converts null to false', ->
          expect(toBool(null)).toEqual false

        it 'converts underfined to false', ->
          expect(toBool(undefined)).toEqual false

      describe 'boolean (already)', ->
        it 'leaves true as true', ->
          expect(toBool(true)).toEqual true

        it 'leaves false as false', ->
          expect(toBool(false)).toEqual false

      describe 'string comparisons', ->
        it 'converts string to true', ->
          expect(toBool('  true ')).toEqual true

        it 'converts string to false', ->
          expect(toBool(' False  ')).toEqual false

        it 'converts string with random value to null', ->
          expect(toBool('foo')).toEqual null

        it 'converts empty string to null', ->
          expect(toBool('   ')).toEqual null
          expect(toBool('')).toEqual null

        describe 'true aliases', ->
          it 'converts yes to true', ->
            expect(toBool('  yes  ')).toEqual true

          it 'converts on to true', ->
            expect(toBool('  on  ')).toEqual true

        describe 'false aliases', ->
          it 'converts no to false', ->
            expect(toBool('  No  ')).toEqual false

          it 'converts off to false', ->
            expect(toBool('  oFF  ')).toEqual false

        describe 'number comparisons', ->
          it 'converts 1 to true', ->
            expect(toBool(1)).toEqual true

          it 'converts 0 to false', ->
            expect(toBool(0)).toEqual false

          it 'converts any other number to null', ->
            expect(toBool(-5)).toEqual null
            expect(toBool(5)).toEqual null
    
    describe 'toJQuery', ->
      toJQuery = null
      beforeEach -> toJQuery = core.util.toJQuery

      it 'returns the given jQuery object with no change', ->
        body = $('body')
        expect(toJQuery(body)).toEqual body

      it 'finds a CSS selector returning a jQuery object', ->
        expect(toJQuery('body')).toEqual $('body')

      it 'returns the jQuery [el] of a [View] object', ->
        view = new core.mvc.View(className:'foo')
        expect(toJQuery(view)).toEqual view.el

      it 'translates an HTML DOM element to a jQuery object', ->
        elBody = $('body').get(0)
        expect(toJQuery(elBody)).toEqual $(elBody)
      
      it 'throws if value type not supported', ->
        expect(-> toJQuery(12345)).toThrow()

      it 'returns value is not defined', ->
        expect(toJQuery()).toEqual undefined
        expect(toJQuery(undefined)).toEqual undefined
        expect(toJQuery(null)).toEqual null

