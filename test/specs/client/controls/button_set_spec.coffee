controls = require 'core/controls'


describe 'controls/button_set', ->
  ButtonSet = controls.ButtonSet
  Button    = controls.Button
  model     = null
  buttons   = null

  btn       = null
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
      model.addButton tab1
      model.addButton tab2
      model.addButton btn
      expect(model.togglable().length).toEqual 2
    
    it 'gets no buttons', ->
      model.addButton(btn)
      expect(model.togglable().length).toEqual 0
  
  describe 'deselecting toggle buttons on press', ->
    beforeEach ->
      model.addButton tab1
      model.addButton tab2
      model.addButton tab3
      model.addButton btn
    
    it 'deselects first tab when second tab selected', ->
      tab1.pressed true
      tab2.pressed true
      expect(tab1.pressed()).toEqual false
      expect(tab2.pressed()).toEqual true
    
    it 'is not effected by changes to non-toggle buttons', ->
      tab1.pressed true
      btn.pressed true
      expect(tab1.pressed()).toEqual true
    
    it 'does not deselect the currently pressed button on click', ->
      tab1.pressed true
      tab1.click()
      expect(tab1.pressed()).toEqual true
  
  describe 'selected (toggle button)', ->
    btn1 = null
    btn2 = null
    beforeEach ->
        btn1 = new Button(label: 'btn1')
        btn2 = new Button(label: 'btn2')

        model.addButton btn1
        model.addButton btn2
        model.addButton tab1
        model.addButton tab2
    
    it 'is empty by default', ->
      expect(model.selected()).toEqual null
    
    it 'returns selected tab', ->
      tab1.pressed true
      tab1.pressed true
      tab1.pressed true
      expect(model.selected()).toEqual tab1
    
    it 'does not include non-toggle buttons', ->
      btn1.pressed true
      btn2.pressed true
      expect(model.selected()).toEqual null
    
    it 'returns the selectedToggle button (first pressed toggle button)', ->
      tab1.pressed true
      tab2.pressed true
      btn1.pressed true
      expect(model.selected()).toEqual tab2
    
    it 'has no selected buttons when tab is un-pressed', ->
      tab1.pressed true
      tab1.pressed false
      expect(model.selected()).toEqual null
    
    it 'does not change the size of the buttons collection', ->
      expect(model.buttons.length).toEqual 4
      expect(model.selected()).toEqual null
      tab1.pressed true
      expect(model.buttons.length).toEqual 4
      expect(model.selected()).toEqual tab1
    
    it 'should have unique collections for buttons and selected', ->
      expect(model.buttons).not.toEqual model.selected
    
    it 'does not cause the add event to fire on the buttons collection', ->
      args = undefined
      model.buttons.bind 'add', (e) -> args = e
      tab1.pressed true
      expect(args).not.toBeDefined()
  
  
  describe 'length', ->
    it 'has no buttons (length == 0)', ->
      expect(model.length).toEqual 0

    it 'has one button', ->
      model.addButton(btn)
      expect(model.length).toEqual 1
    
  
  describe 'addButton', ->
    it 'adds the button to the collection', ->
      model.addButton(btn)
      expect(model.buttons.include(btn)).toEqual true

    it 'returns the added button', ->
      expect(model.addButton(btn)).toEqual btn
    
    it 'throws if button not specified', ->
      expect(-> model.addButton()).toThrow()
    
    it 'causes the change event to fire on the collection', ->
      args = null
      model.buttons.bind 'add', (e) -> args = e
      model.addButton(btn)
      expect(args).toEqual btn

    it 'suppresses the change event', ->
      args = undefined
      model.buttons.bind 'add', (e) -> args = e
      model.addButton(btn, silent:true)
      expect(args).not.toBeDefined()
    
  describe 'clear', ->
    beforeEach ->
      model.addButton new Button(label: 'one')
      model.addButton new Button(label: 'two')
      model.addButton new Button(label: 'three')
    
    it 'fires the clear event', ->
      count = 0
      model.bind 'clear', ->
        count += 1
      
      model.clear()
      expect(count).toEqual 1
    
    it 'does not fire the clear event', ->
      count = 0
      model.bind 'clear', ->
        count += 1
      
      model.clear silent: true
      expect(count).toEqual 0
    
    it 'clears the buttons collection', ->
      model.clear()
      expect(model.buttons.size()).toEqual 0
    
    it 'does fire remove event from buttons collection when cleared', ->
      count = 0
      model.buttons.bind 'remove', ->
        count += 1
      
      model.clear()
      expect(count).toEqual 3
    
    it 'does not fire remove event from buttons collection when cleared', ->
      count = 0
      model.buttons.bind 'remove', ->
        count += 1
      
      model.clear silent: true
      expect(count).toEqual 0
