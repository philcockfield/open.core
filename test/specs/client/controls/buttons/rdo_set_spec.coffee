describe 'controls/buttons/rdo_set', ->
  RadioButtonSet = null
  radioSet       = null
  beforeEach ->
      RadioButtonSet = controls.RadioButtonSet
      radioSet = new RadioButtonSet()
  
  
  it 'exists', ->
    expect(RadioButtonSet).toBeDefined()
  
  it 'is an MVC View', ->
    expect(radioSet instanceof core.mvc.View).toEqual true 
  
  it 'is an unordered list (UL)', ->
    expect(radioSet.el.get(0).tagName.toLowerCase()).toEqual 'ul'
  
  it 'has a [buttons] collection which is a [ButtonSet]', ->
    expect(radioSet.buttons instanceof controls.ButtonSet).toEqual true 
  
  describe 'add() method', ->
    
    it 'returns a Radio Button', ->
      expect(radioSet.add() instanceof controls.RadioButton).toEqual true 
    
    it 'adds the new button so the [buttons] collection', ->
      rdo = radioSet.add()
      expect(radioSet.buttons.contains(rdo)).toEqual true
    
    it 'applies the given option to the new button', ->
      rdo = radioSet.add label:'foo'
      expect(rdo.label()).toEqual 'foo'
    
    it 'inserts the button into the UL within a LI', ->
      rdo = radioSet.add()
      li = radioSet.$ 'li'
      expect(li.length).toEqual 1
      
      elRdo = li.children().get(0)
      expect(elRdo).toEqual rdo.el.get(0)






  