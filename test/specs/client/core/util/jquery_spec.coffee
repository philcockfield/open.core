describe 'client/util (jQuery)', ->
  jqUtil = undefined
  beforeEach ->
      jqUtil = core.util.jQuery
  
  it 'exists', ->
    expect(jqUtil).toBeDefined()
  
  
  describe 'cssNum', ->
    div = null
    beforeEach ->
        div = $ '<div></div>'
    
    it 'exists', ->
      expect(jqUtil.cssNum instanceof Function).toEqual true 
      
    describe 'default result (0)', ->
      it 'returns zero (0) if no element was passed', ->
        expect(jqUtil.cssNum()).toEqual 0
      
      it 'returns zero (0) if no style was passed', ->
        expect(jqUtil.cssNum(div)).toEqual 0
      
      it 'returns zero (0) when the style does not exist', ->
        div.css 'font-size', '10.5pt'
        expect(jqUtil.cssNum(div, 'padding')).toEqual 0
    
    describe 'custom default result (5)', ->
      it 'returns 5 if no element was passed', ->
        expect(jqUtil.cssNum(null, null, 5)).toEqual 5
      
      it 'returns 5 if no style was passed', ->
        expect(jqUtil.cssNum(div, null, 5)).toEqual 5
      
      it 'returns 5 when the style does not exist', ->
        div.css 'font-size', '10.5pt'
        expect(jqUtil.cssNum(div, 'padding', 5)).toEqual 5
    
    it 'returns a number', ->
      div.css 'margin-top', '10px'
      expect(jqUtil.cssNum(div, 'margin-top')).toEqual 10

    it 'returns a negative number', ->
      div.css 'margin-top', '-10px'
      expect(jqUtil.cssNum(div, 'margin-top')).toEqual -10

    it 'returns a floating point number', ->
      div.css 'font-size', '10.5px'
      expect(jqUtil.cssNum(div, 'font-size')).toEqual 10.5
    
  