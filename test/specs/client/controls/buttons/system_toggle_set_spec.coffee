describe 'controls/buttons/system_toggle_set', ->
  SystemToggleSet = null
  toggleSet      = null
  beforeEach ->
      SystemToggleSet = controls.SystemToggleSet
      toggleSet       = new controls.RadioButtonSet() # Use the dervied radio-button version for testing.
  
  it 'exists', ->
    expect(controls.SystemToggleSet).toBeDefined()
  
  it 'is a [ControlList]', ->
    expect(toggleSet instanceof controls.ControlList).toEqual true 
  
  it 'has a [buttons] collection which is a [ButtonSet]', ->
    expect(toggleSet.buttons instanceof controls.ButtonSet).toEqual true 
  
  it 'retrieves the [selected] button', ->
    rdo1 = toggleSet.add()
    rdo2 = toggleSet.add()
    rdo2.selected true
    expect(toggleSet.selected()).toEqual rdo2
  
  describe 'count() method', ->
    it 'has 0 buttons', -> expect(toggleSet.count()).toEqual 0
    it 'has 3 buttons', ->
      toggleSet.add()
      toggleSet.add()
      toggleSet.add()
      expect(toggleSet.count()).toEqual 3
  
  describe 'add() method', ->
    it 'returns a new Button', ->
      expect(toggleSet.add() instanceof toggleSet.ButtonType).toEqual true 
    
    it 'adds the new button to the [buttons] collection', ->
      rdo = toggleSet.add()
      expect(toggleSet.buttons.contains(rdo)).toEqual true
    
    it 'calls the base add() method', ->
      args = null
      spyOn(SystemToggleSet.__super__, 'add').andCallFake (e) -> args = e
      rdo = toggleSet.add()
      expect(args).toEqual rdo
    
    it 'applies the given option to the new button', ->
      rdo = toggleSet.add label:'foo'
      expect(rdo.label()).toEqual 'foo'
    
    it 'inserts the button into the UL within an LI', ->
      rdo = toggleSet.add()
      li = toggleSet.$ 'li'
      expect(li.length).toEqual 1
      
      elRdo = li.children().get(0)
      expect(elRdo).toEqual rdo.el.get(0)

  describe 'events', ->
    it 'fires the [selectionChanged] event', ->
      rdo1 = toggleSet.add()
      rdo2 = toggleSet.add()
      
      args      = null
      fireCount = 0
      toggleSet.bind 'selectionChanged', (e) -> 
                                          args = e
                                          fireCount += 1
      rdo2.click()
      expect(fireCount).toEqual 1
      expect(args.button).toEqual rdo2




  