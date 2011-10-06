describe 'controls/buttons/rdo_set', ->
  RadioButtonSet = null
  radioSet       = null
  beforeEach ->
      RadioButtonSet = controls.RadioButtonSet
      radioSet = new RadioButtonSet()
  
  
  it 'exists', ->
    expect(RadioButtonSet).toBeDefined()
  
  it 'is a [ControlList]', ->
    expect(radioSet instanceof controls.ControlList).toEqual true 
  
  it 'has a CSS class', ->
    expect(radioSet.el.hasClass('core_radio_set')).toEqual true
  
  it 'has a [buttons] collection which is a [ButtonSet]', ->
    expect(radioSet.buttons instanceof controls.ButtonSet).toEqual true 
  
  it 'retrieves the [selected] button', ->
      rdo1 = radioSet.add()
      rdo2 = radioSet.add()
      rdo2.selected true
      expect(radioSet.selected()).toEqual rdo2
  
  
  describe 'add() method', ->
    it 'returns a Radio Button', ->
      expect(radioSet.add() instanceof controls.RadioButton).toEqual true 
    
    it 'adds the new button to the [buttons] collection', ->
      rdo = radioSet.add()
      expect(radioSet.buttons.contains(rdo)).toEqual true
    
    it 'calls the base add() method', ->
      args = null
      spyOn(RadioButtonSet.__super__, 'add').andCallFake (e) -> args = e
      rdo = radioSet.add()
      expect(args).toEqual rdo
    
    it 'applies the given option to the new button', ->
      rdo = radioSet.add label:'foo'
      expect(rdo.label()).toEqual 'foo'
    
    it 'inserts the button into the UL within an LI', ->
      rdo = radioSet.add()
      li = radioSet.$ 'li'
      expect(li.length).toEqual 1
      
      elRdo = li.children().get(0)
      expect(elRdo).toEqual rdo.el.get(0)

  describe 'events', ->
    it 'fires the [selectionChanged] event', ->
      rdo1 = radioSet.add()
      rdo2 = radioSet.add()
      
      args      = null
      fireCount = 0
      radioSet.bind 'selectionChanged', (e) -> 
                                          args = e
                                          fireCount += 1
      
      rdo2.click()
      expect(fireCount).toEqual 1
      expect(args.button).toEqual rdo2




  