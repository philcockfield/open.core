describe 'controls/button_set', ->
  ButtonSet = controls.ButtonSet
  Button    = controls.Button
  model     = null
  buttons   = null

  btn  = null
  tab1 = null
  tab2 = null
  tab3 = null

  beforeEach ->
    model = new ButtonSet()
    buttons = model.buttons

    btn = new Button(label:'My Button')
    tab1 = new Button(label: 'tab1', canToggle:true)
    tab2 = new Button(label: 'tab2', canToggle:true)
    tab3 = new Button(label: 'tab3', canToggle:true)
    
  
  it 'exists', ->
    expect(controls.ButtonSet).toBeDefined()

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled ButtonSet, -> new ButtonSet()

  
  describe 'buttons collection', ->
    it 'is an MVC Collection', ->
      expect(model.buttons instanceof core.mvc.Collection).toEqual true
    
    it 'is empty by default', ->
      expect(buttons.size()).toEqual 0
  
  describe 'togglable', ->
    it 'gets only the toggle buttons', ->
      model.add tab1
      model.add tab2
      model.add btn
      expect(model.togglable().length).toEqual 2
    
    it 'gets no buttons', ->
      model.add(btn)
      expect(model.togglable().length).toEqual 0
  
  describe 'deselecting toggle buttons on press', ->
    beforeEach ->
      model.add tab1
      model.add tab2
      model.add tab3
      model.add btn
    
    it 'deselects first tab when second tab selected', ->
      tab1.selected true
      tab2.selected true
      expect(tab1.selected()).toEqual false
      expect(tab2.selected()).toEqual true
    
    it 'is not effected by changes to non-toggle buttons', ->
      tab1.selected true
      btn.selected true
      expect(tab1.selected()).toEqual true
    
    it 'does not deselect the currently selected button on click', ->
      tab1.selected true
      tab1.click()
      expect(tab1.selected()).toEqual true
  
  describe 'selected (toggle button)', ->
    btn1 = null
    btn2 = null
    beforeEach ->
        btn1 = new Button(label: 'btn1')
        btn2 = new Button(label: 'btn2')

        model.add btn1
        model.add btn2
        model.add tab1
        model.add tab2
    
    it 'is empty by default', ->
      expect(model.selected()).toEqual null
    
    it 'returns selected tab', ->
      tab1.selected true
      tab1.selected true
      tab1.selected true
      expect(model.selected()).toEqual tab1
    
    it 'does not include non-toggle buttons', ->
      btn1.selected true
      btn2.selected true
      expect(model.selected()).toEqual null
    
    it 'returns the selectedToggle button (first selected toggle button)', ->
      tab1.selected true
      tab2.selected true
      btn1.selected true
      expect(model.selected()).toEqual tab2
    
    it 'has no selected buttons when tab is un-selected', ->
      tab1.selected true
      tab1.selected false
      expect(model.selected()).toEqual null
    
    it 'does not change the size of the buttons collection', ->
      expect(model.buttons.length).toEqual 4
      expect(model.selected()).toEqual null
      tab1.selected true
      expect(model.buttons.length).toEqual 4
      expect(model.selected()).toEqual tab1
    
    it 'should have unique collections for buttons and selected', ->
      expect(model.buttons).not.toEqual model.selected
    
    it 'does not cause the add event to fire on the buttons collection', ->
      args = undefined
      model.buttons.bind 'add', (e) -> args = e
      tab1.selected true
      expect(args).not.toBeDefined()
  
  
  describe 'length', ->
    it 'has no buttons (length == 0)', ->
      expect(model.length).toEqual 0

    it 'incremenets the length upon add', ->
      model.add(btn)
      expect(model.length).toEqual 1

    it 'decrements the length upon add', ->
      model.add(btn)
      model.remove(btn)
      model.remove(btn)
      expect(model.length).toEqual 0
    
  
  describe 'add() method', ->
    it 'adds the button to the collection', ->
      model.add(btn)
      expect(model.buttons.include(btn)).toEqual true

    it 'returns the added button', ->
      expect(model.add(btn)).toEqual btn
    
    it 'throws if button not specified', ->
      expect(-> model.add()).toThrow()
    
    it 'does not add the same button twice', ->
      model.add btn
      model.add btn
      expect(model.length).toEqual 1
    
    it 'causes the change event to fire on the collection', ->
      args = null
      model.buttons.bind 'add', (e) -> args = e
      model.add(btn)
      expect(args).toEqual btn

    it 'suppresses the change event when [silent:true]', ->
      args = undefined
      model.buttons.bind 'add', (e) -> args = e
      model.add(btn, silent:true)
      expect(args).not.toBeDefined()
    
    it 'fires [add] event from ButtonSet', ->
      args = undefined
      model.bind 'add', (e) -> args = e
      model.add(btn)
      expect(args.source).toEqual model

    it 'does not fire [add] event from ButtonSet when [silent:true]', ->
      args = undefined
      model.bind 'add', (e) -> args = e
      model.add(btn, silent:true)
      expect(args).not.toBeDefined()

    
  describe 'remove', ->
    beforeEach ->
        model.add(btn)
    
    it 'removes the button from the collection', ->
      model.remove(btn)
      expect(model.buttons.include(btn)).toEqual false
      
    it 'returns the true if removed successfully', ->
      expect(model.remove(btn)).toEqual true

    it 'returns the false if the button was no in the set', ->
      expect(model.remove(new Button())).toEqual false
    
    it 'fires [remove] event', ->
      args = undefined
      model.bind 'remove', (e) -> args = e
      model.remove(btn)
      expect(args.source).toEqual model
      
    it 'does not fire [remove] event when [silent:true]', ->
      args = undefined
      model.bind 'remove', (e) -> args = e
      model.remove(btn, silent:true)
      expect(args).not.toBeDefined()
    
    
  describe 'clear() method', ->
    beforeEach ->
      model.add new Button(label: 'one')
      model.add new Button(label: 'two')
      model.add new Button(label: 'three')
    
    it 'fires the [clear] event', ->
      count = 0
      model.bind 'clear', ->
        count += 1
      
      model.clear()
      expect(count).toEqual 1
    
    it 'does not fire the [clear] event', ->
      count = 0
      model.bind 'clear', ->
        count += 1
      
      model.clear silent: true
      expect(count).toEqual 0
    
    it 'clears the buttons collection', ->
      model.clear()
      expect(model.buttons.size()).toEqual 0
    
    describe '[remove] event', ->
      it 'does fire [remove] event from buttons collection when cleared', ->
        count = 0
        model.buttons.bind 'remove', -> count += 1
        model.clear()
        expect(count).toEqual 3
    
      it 'does not fire [remove] event from buttons collection when cleared  (silent:true)', ->
        count = 0
        model.buttons.bind 'remove', -> count += 1
        model.clear silent: true
        expect(count).toEqual 0

      it 'does fire [remove] event from the ButtonSet when cleared', ->
        count = 0
        model.bind 'remove', -> count += 1
        model.clear()
        expect(count).toEqual 3
    
      it 'does not fire [remove] event from the ButtonSet when cleared (silent:true)', ->
        count = 0
        model.bind 'remove', -> count += 1
        model.clear silent: true
        expect(count).toEqual 0


  describe '[changed] event', ->
    fireCount = 0
    beforeEach ->
        fireCount = 0
        model.bind 'changed', -> fireCount += 1
    
    it 'fires [changed] event when button is added', ->
      model.add btn
      model.add btn
      expect(fireCount).toEqual 1
      
    it 'fires [changed] event when button is removed', ->
      model.add btn
      fireCount = 0
      model.remove btn
      expect(fireCount).toEqual 1
      
    it 'fires [changed] event once when cleared', ->
      model.add new Button()
      model.add new Button()
      model.add new Button()
      fireCount = 0
      model.clear()
      expect(fireCount).toEqual 1
    
    describe 'suppressed (silent:true)', ->
      it 'does not fire [changed] event when button is added', ->
        model.add btn, silent:true
        model.add btn, silent:true
        expect(fireCount).toEqual 0
      
      it 'does not fire [changed] event when button is removed', ->
        model.add btn
        fireCount = 0
        model.remove btn, silent:true
        expect(fireCount).toEqual 0
      
      it 'does not fire [changed] event when cleared', ->
        model.add new Button()
        model.add new Button()
        model.add new Button()
        fireCount = 0
        model.clear(silent:true)
        expect(fireCount).toEqual 0
      
    
  describe '[selectionChanged] event', ->
    count = 0
    args = null
    beforeEach ->
        count = 0
        args = null
        model.bind 'selectionChanged', (e) -> 
            args = e
            count += 1
    
    it 'fires [selectionChanged] once', ->
      model.add tab1
      model.add tab2
      tab2.click()
      tab2.click()
      expect(count).toEqual 1

    it 'passes the [ButtonSet] in event args', ->
      model.add tab1
      tab1.click()
      expect(args.source).toEqual model

    it 'passes the button in event args', ->
      model.add tab1
      model.add tab2
      tab2.click()
      expect(args.button).toEqual tab2
      
    
  describe 'Collection methods', ->
    describe '[contains] method', ->
      it 'determines if a button is contained within the set', ->
        model.add tab1
        expect(model.contains(tab1)).toEqual true

      it 'determines if a button is not contained within the set', ->
        model.add tab1
        expect(model.contains(tab2)).toEqual false
        
      
      
    
    
    
    
    
      
            
    
      
      
    
