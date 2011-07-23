describe 'client/util', ->
  describe 'toBool', ->
    toBool = null
    beforeEach -> toBool = core.util.toBool

    it 'converts string to true', ->
      expect(toBool('true')).toEqual true

    it 'converts string to false', ->
      expect(toBool('false')).toEqual false

    it 'converts string with random value to false', ->
      expect(toBool('foo')).toEqual false

    it 'converts empty string to false', ->
      expect(toBool('')).toEqual false

    it 'converts null to false', ->
      expect(toBool(null)).toEqual false

    it 'converts underfined to false', ->
      expect(toBool(undefined)).toEqual false

    it 'converts object to null', ->
      expect(toBool({ foo:123 })).toEqual null

