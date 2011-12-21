describe 'core/util/underscore', ->
  describe 'underscore.string', ->
    describe 'isBlank()', ->
      it 'is not blank', ->
        expect(_('   foo   ').isBlank()).toEqual false
        expect(_.isBlank('   foo   ')).toEqual false
      
      it 'is blank with empty-string', ->
        expect(_('').isBlank()).toEqual true
        expect(_.isBlank('')).toEqual true
        
      it 'is blank with white-space', ->
        expect(_('  ').isBlank()).toEqual true
        expect(_.isBlank('  ')).toEqual true
      
      it 'is blank with null', ->
        expect(_.isBlank(null)).toEqual true
        
      it 'is blank with nothing', ->
        expect(_.isBlank()).toEqual true
      
      it 'is blank with undefined', ->
        expect(_.isBlank(undefined)).toEqual true
    
    describe 'nullIfBlank()', ->
      it 'does not convert to null', ->
        expect(_('foo').nullIfBlank()).toEqual 'foo'
        expect(_.nullIfBlank('foo')).toEqual 'foo'
      
      it 'converts empty-string to null', ->
        expect(_.nullIfBlank('')).toEqual null
        
      it 'converts white-space to null', ->
        expect(_.nullIfBlank('    ')).toEqual null
        
      it 'converts undefined to null', ->
        expect(_.nullIfBlank(undefined)).toEqual null
        
      it 'converts nothing to null', ->
        expect(_.nullIfBlank()).toEqual null
        
      it 'returns null', ->
        expect(_.nullIfBlank(null)).toEqual null
      
      
