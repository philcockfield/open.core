describe 'util/string', ->
  describe 'underscore.string extensions', ->
    describe 'captialize', ->
      
      describe 'as param of underscore', ->
        it 'capitalizes the first letter', ->
          expect(_('the').capitalize()).toEqual 'The'
      
      describe 'as param of method', ->
        it 'capitalizes the first letter', ->
          expect(_.capitalize('the')).toEqual 'The'
        
        it 'capitalizes a single letter', ->
          expect(_.capitalize('a')).toEqual 'A'
        
        it 'does not change the remainder of the string', ->
          expect(_.capitalize('the Cat')).toEqual 'The Cat'
        
        describe 'non-values', ->
          it 'returns empty string', ->
            expect(_.capitalize('')).toEqual ''
        
          it 'returns null', ->
            expect(_.capitalize(null)).toEqual null
        
          it 'returns undefined', ->
            expect(_.capitalize()).toEqual undefined
        
        describe 'non-string types', ->
          it 'returns a number unchanged', ->
            expect(_.capitalize(123)).toEqual 123
          
          it 'returns a boolean unchanged', ->
            expect(_.capitalize(true)).toEqual true



