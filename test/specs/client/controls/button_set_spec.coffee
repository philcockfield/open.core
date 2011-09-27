describe 'controls/button_set', ->
  ButtonSet = controls.ButtonSet
  Button    = controls.Button
  buttons   = null

  btn  = null
  tab1 = null
  tab2 = null
  tab3 = null

  beforeEach ->
    buttons = new ButtonSet()
    btn     = new Button(label:'My Button')
    tab1    = new Button(label: 'tab1', canToggle:true)
    tab2    = new Button(label: 'tab2', canToggle:true)
    tab3    = new Button(label: 'tab3', canToggle:true)
    
  
  it 'exists', ->
    expect(controls.ButtonSet).toBeDefined()

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled ButtonSet, -> new ButtonSet()

  
  describe 'buttons collection', ->
    it 'is an MVC Collection', ->
      expect(buttons.items instanceof core.mvc.Collection).toEqual true
    
    it 'is empty by default', ->
      expect(buttons.items.size()).toEqual 0
  
  describe 'togglable', ->
    it 'gets only the toggle buttons', ->
      buttons.add tab1
      buttons.add tab2
      buttons.add btn
      expect(buttons.togglable().length).toEqual 2
    
    it 'gets no buttons', ->
      buttons.add(btn)
      expect(buttons.togglable().length).toEqual 0
  
  describe 'deselecting toggle buttons on press', ->
    beforeEach ->
      buttons.add tab1
      buttons.add tab2
      buttons.add tab3
      buttons.add btn
    
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
  
  describe 'item() method', ->
    btn1 = null
    btn2 = null
    beforeEach ->
        btn1 = buttons.add new Button(label: 'btn1')
        btn2 = buttons.add new Button(label: 'btn2')

    it 'returns the first button', ->
      expect(buttons.item(0)).toEqual btn1
      
    it 'returns the second button', ->
      expect(buttons.item(1)).toEqual btn2
    
    it 'returns null when index is out of bounds', ->
      expect(buttons.item(-1)).toEqual null
      expect(buttons.item(2)).toEqual null

    it 'returns null when collection is empty', ->
      buttons.clear()
      expect(buttons.item(0)).toEqual null
  
  describe 'selected (toggle button)', ->
    btn1 = null
    btn2 = null
    beforeEach ->
        btn1 = buttons.add new Button(label: 'btn1')
        btn2 = buttons.add new Button(label: 'btn2')
        buttons.add tab1
        buttons.add tab2
    
    it 'is empty by default', ->
      expect(buttons.selected()).toEqual null
    
    it 'returns selected tab', ->
      tab1.selected true
      tab1.selected true
      tab1.selected true
      expect(buttons.selected()).toEqual tab1
    
    it 'does not include non-toggle buttons', ->
      btn1.selected true
      btn2.selected true
      expect(buttons.selected()).toEqual null
    
    it 'returns the selectedToggle button (first selected toggle button)', ->
      tab1.selected true
      tab2.selected true
      btn1.selected true
      expect(buttons.selected()).toEqual tab2
    
    it 'has no selected buttons when tab is un-selected', ->
      tab1.selected true
      tab1.selected false
      expect(buttons.selected()).toEqual null
    
    it 'does not change the size of the buttons collection', ->
      expect(buttons.items.length).toEqual 4
      expect(buttons.selected()).toEqual null
      tab1.selected true
      expect(buttons.items.length).toEqual 4
      expect(buttons.selected()).toEqual tab1
    
    it 'should have unique collections for buttons and selected', ->
      expect(buttons.items).not.toEqual buttons.selected
    
    it 'does not cause the add event to fire on the buttons collection', ->
      args = undefined
      buttons.items.bind 'add', (e) -> args = e
      tab1.selected true
      expect(args).not.toBeDefined()
  
  
  describe 'length', ->
    it 'has no buttons (length == 0)', ->
      expect(buttons.length).toEqual 0

    it 'incremenets the length upon add', ->
      buttons.add(btn)
      expect(buttons.length).toEqual 1

    it 'decrements the length upon add', ->
      buttons.add(btn)
      buttons.remove(btn)
      buttons.remove(btn)
      expect(buttons.length).toEqual 0
    
  
  describe 'add() method', ->
    it 'adds the button to the collection', ->
      buttons.add(btn)
      expect(buttons.items.include(btn)).toEqual true

    it 'returns the added button', ->
      expect(buttons.add(btn)).toEqual btn
    
    it 'throws if button not specified', ->
      expect(-> buttons.add()).toThrow()
    
    it 'does not add the same button twice', ->
      buttons.add btn
      buttons.add btn
      expect(buttons.length).toEqual 1
    
    it 'causes the change event to fire on the collection', ->
      args = null
      buttons.items.bind 'add', (e) -> args = e
      buttons.add(btn)
      expect(args).toEqual btn

    it 'suppresses the change event when [silent:true]', ->
      args = undefined
      buttons.items.bind 'add', (e) -> args = e
      buttons.add(btn, silent:true)
      expect(args).not.toBeDefined()
    
    it 'fires [add] event from ButtonSet', ->
      args = undefined
      buttons.bind 'add', (e) -> args = e
      buttons.add(btn)
      expect(args.source).toEqual buttons

    it 'does not fire [add] event from ButtonSet when [silent:true]', ->
      args = undefined
      buttons.bind 'add', (e) -> args = e
      buttons.add(btn, silent:true)
      expect(args).not.toBeDefined()

    
  describe 'remove', ->
    beforeEach ->
        buttons.add(btn)
    
    it 'removes the button from the collection', ->
      buttons.remove(btn)
      expect(buttons.items.include(btn)).toEqual false
      
    it 'returns the true if removed successfully', ->
      expect(buttons.remove(btn)).toEqual true

    it 'returns the false if the button was no in the set', ->
      expect(buttons.remove(new Button())).toEqual false
    
    it 'fires [remove] event', ->
      args = undefined
      buttons.bind 'remove', (e) -> args = e
      buttons.remove(btn)
      expect(args.source).toEqual buttons
      
    it 'does not fire [remove] event when [silent:true]', ->
      args = undefined
      buttons.bind 'remove', (e) -> args = e
      buttons.remove(btn, silent:true)
      expect(args).not.toBeDefined()
    
    
  describe 'clear() method', ->
    beforeEach ->
      buttons.add new Button(label: 'one')
      buttons.add new Button(label: 'two')
      buttons.add new Button(label: 'three')
    
    it 'fires the [clear] event', ->
      count = 0
      buttons.bind 'clear', ->
        count += 1
      
      buttons.clear()
      expect(count).toEqual 1
    
    it 'does not fire the [clear] event', ->
      count = 0
      buttons.bind 'clear', ->
        count += 1
      
      buttons.clear silent: true
      expect(count).toEqual 0
    
    it 'clears the buttons collection', ->
      buttons.clear()
      expect(buttons.items.size()).toEqual 0
    
    describe '[remove] event', ->
      it 'does fire [remove] event from buttons collection when cleared', ->
        count = 0
        buttons.items.bind 'remove', -> count += 1
        buttons.clear()
        expect(count).toEqual 3
    
      it 'does not fire [remove] event from buttons collection when cleared  (silent:true)', ->
        count = 0
        buttons.items.bind 'remove', -> count += 1
        buttons.clear silent: true
        expect(count).toEqual 0

      it 'does fire [remove] event from the ButtonSet when cleared', ->
        count = 0
        buttons.bind 'remove', -> count += 1
        buttons.clear()
        expect(count).toEqual 3
    
      it 'does not fire [remove] event from the ButtonSet when cleared (silent:true)', ->
        count = 0
        buttons.bind 'remove', -> count += 1
        buttons.clear silent: true
        expect(count).toEqual 0


  describe '[changed] event', ->
    fireCount = 0
    beforeEach ->
        fireCount = 0
        buttons.bind 'changed', -> fireCount += 1
    
    it 'fires [changed] event when button is added', ->
      buttons.add btn
      buttons.add btn
      expect(fireCount).toEqual 1
      
    it 'fires [changed] event when button is removed', ->
      buttons.add btn
      fireCount = 0
      buttons.remove btn
      expect(fireCount).toEqual 1
      
    it 'fires [changed] event once when cleared', ->
      buttons.add new Button()
      buttons.add new Button()
      buttons.add new Button()
      fireCount = 0
      buttons.clear()
      expect(fireCount).toEqual 1
    
    describe 'suppressed (silent:true)', ->
      it 'does not fire [changed] event when button is added', ->
        buttons.add btn, silent:true
        buttons.add btn, silent:true
        expect(fireCount).toEqual 0
      
      it 'does not fire [changed] event when button is removed', ->
        buttons.add btn
        fireCount = 0
        buttons.remove btn, silent:true
        expect(fireCount).toEqual 0
      
      it 'does not fire [changed] event when cleared', ->
        buttons.add new Button()
        buttons.add new Button()
        buttons.add new Button()
        fireCount = 0
        buttons.clear(silent:true)
        expect(fireCount).toEqual 0
      
    
  describe '[selectionChanged] event', ->
    count = 0
    args = null
    beforeEach ->
        count = 0
        args = null
        buttons.bind 'selectionChanged', (e) -> 
            args = e
            count += 1
    
    it 'fires [selectionChanged] once', ->
      buttons.add tab1
      buttons.add tab2
      tab2.click()
      tab2.click()
      expect(count).toEqual 1

    it 'passes the [ButtonSet] in event args', ->
      buttons.add tab1
      tab1.click()
      expect(args.source).toEqual buttons

    it 'passes the button in event args', ->
      buttons.add tab1
      buttons.add tab2
      tab2.click()
      expect(args.button).toEqual tab2
      
    
  describe 'Collection methods', ->
    describe '[contains] method', ->
      it 'determines if a button is contained within the set', ->
        buttons.add tab1
        expect(buttons.contains(tab1)).toEqual true

      it 'determines if a button is not contained within the set', ->
        buttons.add tab1
        expect(buttons.contains(tab2)).toEqual false


  describe 'siblings', ->
    btn1 = null
    btn2 = null
    btn3 = null
    
    beforeEach ->
        btn1 = buttons.add new Button()
        btn2 = buttons.add new Button()
        btn3 = buttons.add new Button()
    
    describe 'previous', ->
      it 'returns the null when no button is passed', ->
        expect(buttons.previous()).toEqual null
      
      it 'returns the null as the button previous to the first button', ->
        expect(buttons.previous(btn1)).toEqual null
      
      it 'returns the previous button', ->
        expect(buttons.previous(btn2)).toEqual btn1
    
    describe 'next', ->
      it 'returns the null when no button is passed', ->
        expect(buttons.next()).toEqual null
      
      it 'returns the null as the button next to the last button', ->
        expect(buttons.next(btn3)).toEqual null
      
      it 'returns the next button', ->
        expect(buttons.next(btn2)).toEqual btn3


  describe 'mouse events', ->
    btn1      = null
    btn2      = null
    fireCount = 0
    args      = null
    
    beforeEach ->
        fireCount = 0
        args      = null
        btn1      = buttons.add new Button()
        btn2      = buttons.add new Button()
        btn2.click()

    describe '[mouseUp]', ->
      beforeEach ->
          buttons.bind 'mouseUp', (e) -> 
                                  args = e
                                  fireCount += 1
      
      it 'fires on the un-selected button', ->
        btn1.el.mouseup()
        expect(fireCount).toEqual 1
        expect(args.button).toEqual btn1
        
      it 'fires on the selected button', ->
        btn2.el.mouseup()
        expect(fireCount).toEqual 1
        expect(args.button).toEqual btn2
      
      it 'removes event handler', ->
        buttons.remove btn1
        btn1.el.mouseup()
        expect(fireCount).toEqual 0

    describe '[mouseDown]', ->
      beforeEach ->
          buttons.bind 'mouseDown', (e) -> 
                                  args = e
                                  fireCount += 1
      
      it 'fires on the un-selected button', ->
        btn1.el.mousedown()
        expect(fireCount).toEqual 1
        expect(args.button).toEqual btn1
        
      it 'fires on the selected button', ->
        btn2.el.mousedown()
        expect(fireCount).toEqual 1
        expect(args.button).toEqual btn2
      
      it 'removes event handler', ->
        buttons.remove btn1
        btn1.el.mousedown()
        expect(fireCount).toEqual 0





