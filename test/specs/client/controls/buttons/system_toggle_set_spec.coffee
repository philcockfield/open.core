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
  
  describe 'count() method', ->
    it 'has two items', ->
      toggleSet.add()
      toggleSet.add()
      expect(toggleSet.count()).toEqual 2
  
  describe 'clear() method', ->
    it 'does nothing when there are not buttons', ->
      toggleSet.clear()
      expect(toggleSet.buttons.length).toEqual 0
      expect(toggleSet.count()).toEqual 0
    
    it 'removes items from the collection', ->
      toggleSet.add()
      toggleSet.add()
      toggleSet.clear()
      expect(toggleSet.count()).toEqual 0
      expect(toggleSet.buttons.length).toEqual 0
  
    it 'removes items from the DOM', ->
      toggleSet.add()
      toggleSet.add()
      toggleSet.clear()
  
  describe 'init() method', ->
    buttons = [
      { label:'one' }
      { label:'two' }
    ]
    
    it 'returns the [toggleSet] instance', ->
      expect(toggleSet.init()).toEqual toggleSet
    
    it 'passes the buttons to the [add] method', ->
      spyOn(toggleSet, 'add')
      toggleSet.init buttons
      expect(toggleSet.add.calls[0].args[0]).toEqual buttons[0]
      expect(toggleSet.add.calls[1].args[0]).toEqual buttons[1]
    
    it 'clears before initializing', ->
      spyOn(toggleSet, 'clear')
      toggleSet.init buttons
      expect(toggleSet.clear).toHaveBeenCalled()
  
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




  