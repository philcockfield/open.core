describe 'controls/button', ->
  Button = null
  button = null
  beforeEach ->
      Button = controls.Button
      button = new Button()
  
  it 'exists', ->
    expect(Button).toBeDefined()
  
  it 'is an MVC view', ->
    expect(button instanceof core.mvc.View).toEqual true 

  
  describe 'default property values', ->
    it 'is enabled by default', ->
      expect(button.enabled()).toEqual true
    
    it 'is visible by default', ->
      expect(button.visible()).toEqual true
  
    it 'is not selected by default', ->
      expect(button.selected()).toEqual false

    it 'is not in a [mouse] over state by default', ->
      expect(button.over()).toEqual false

    it 'is not in a [mouse] down state by default', ->
      expect(button.down()).toEqual false
    
    it 'is does not toggle by default', ->
      expect(button.canToggle()).toEqual false
    
    it 'has no text label by default', ->
      expect(button.label()).toEqual ''


  describe 'constructor', ->
    it 'recieves custom [label] from constructor', ->
      button = new Button(label:'foo')
      expect(button.label()).toEqual 'foo'

    it 'recieves custom [selected] value from constructor', ->
      button = new Button(selected: true)
      expect(button.selected()).toEqual true

    it 'recieves custom [canToggle] value from constructor', ->
      button = new Button(canToggle: true)
      expect(button.canToggle()).toEqual true
      
    it 'passes tagName to base class', ->
      button = new Button(tagName: 'a')
      expect(button.element.tagName).toEqual 'A'

    it 'passes className to base class', ->
      button = new Button(className: 'foo bar')
      expect(button.element.className).toEqual 'foo bar'
    
    it 'syncs CSS classes upon construction', ->
      button = new Button(selected:true)
      expect(button.el.hasClass('core_selected')).toEqual true
  
    
  describe 'click (method and event)', ->
    args = null
    fireCount = null
    beforeEach ->
      button.bind 'click', (e) ->
                      args = e
                      fireCount += 1
      
      args = null
      fireCount = 0

    it 'fires event when click method is invoked', ->
      button.click()
      expect(fireCount).toEqual 1
    
    it 'does not fire event when click method is invoked silently', ->
      button.click silent: true
      expect(fireCount).toEqual 0

    it 'does not fire event when the model is disabled', ->
      button.enabled false
      button.click()
      expect(fireCount).toEqual 0
    
    it 'returns the model as the event args', ->
      button.click()
      expect(args.source).toEqual button
    
  describe 'toggling Selected', ->
    describe 'when canToggle is true', ->
      beforeEach ->
        button.canToggle true
      
      it 'toggles selected to true', ->
        button.click()
        expect(button.selected()).toEqual true
      
      it 'toggles selected to false', ->
        button.click()
        button.click()
        expect(button.selected()).toEqual false

      it 'does not toggle when disabled', ->
        expect(button.selected()).toEqual false
        button.enabled false
        button.click()
        expect(button.selected()).toEqual false
  
    describe 'when [canToggle] is false', ->
      beforeEach ->
        button.canToggle false
      
      it 'does not change selected value', ->
        button.click()
        expect(button.selected()).toEqual false
  
  describe '[selected] and [down] state', ->
    beforeEach -> 
        button.canToggle true
        
    it 'is not down when selected (on mouse events)', ->
      button.el.mousedown()
      button.el.mouseup()
      expect(button.selected()).toEqual true
      expect(button.down()).toEqual false
      
    it 'is not down when selected (on [click] method)', ->
      button.click()
      expect(button.selected()).toEqual true
      expect(button.down()).toEqual false

  describe 'onClick : event handler helper', ->
    it 'wires up event handler', ->
      onClickCount = 0
      button.onClick ->
        onClickCount += 1
      
      button.click()
      expect(onClickCount).toEqual 1
    
    it 'wire up multiple event handlers', ->
      fire1 = 0
      fire2 = 0
      button.onClick ->
        fire1 += 1
      
      button.onClick ->
        fire2 += 1
      
      button.click()
      expect(fire1).toEqual 1
      expect(fire2).toEqual 1


  describe '[pre:click] event', ->
    preArgs = undefined
    clickArgs = undefined
    beforeEach ->
            e = undefined
            clickArgs = undefined
            button.bind 'pre:click', (e) -> preArgs = e
            button.onClick (e)-> clickArgs = e
  
    it 'fires a [pre:click] event', ->
      button.click()
      expect(preArgs).toBeDefined()
  
    it 'does not fire the [click] event if the [pre:event] was cancelled', ->
      button.bind 'pre:click', (e) -> e.cancel = true
      button.click()
      expect(clickArgs).not.toBeDefined()
  
    it 'does not toggle if the [pre:event] was cancelled', ->
      button.bind 'pre:click', (e) -> e.cancel = true
      button.canToggle(true);
      button.click()
      expect(button.selected()).toEqual false
    
    it 'returns true if the click was not cancelled', ->
      button.bind 'pre:click', (e) -> e.cancel = false
      result = button.click()
      expect(result).toEqual true

    it 'returns false if the click was cancelled', ->
      button.bind 'pre:click', (e) -> e.cancel = true
      result = button.click()
      expect(result).toEqual false
      
  
  describe '[selected] event', ->
    e = undefined
    beforeEach ->
            e = undefined
            button.canToggle true
            button.bind 'selected', (args) -> e = args
    
    it 'fires selected event when selected', ->
      button.selected true
      expect(e.source).toEqual button
    
    it 'does not fire selected event when un-selected', ->
      button.selected true
      e = null
      button.selected false
      expect(e).toEqual null
    
    it 'does not fire selected event if button does not toggle', ->
      button.canToggle false
      button.selected true
      expect(e).not.toBeDefined()


  describe 'onSelected : event handler helper', ->
    beforeEach ->
        button.canToggle true
    
    it 'wires up event handler', ->
      onSelectedCount = 0
      button.onSelected ->
          onSelectedCount += 1
      
      button.click()
      expect(onSelectedCount).toEqual 1
    
    it 'wire up multiple event handlers', ->
      fire1 = 0
      fire2 = 0
      button.onSelected ->
        fire1 += 1
      
      button.onClick ->
        fire2 += 1
      
      button.click()
      expect(fire1).toEqual 1
      expect(fire2).toEqual 1  

  describe 'toggle', ->
    it 'does not toggle if [canToggle] is false', ->
      button.canToggle false
      button.toggle()
      expect(button.selected()).toEqual false

    it 'returns false if cannot toggle', ->
      button.canToggle false
      expect(button.toggle()).toEqual false

    it 'returns true if can toggle', ->
      button.canToggle true
      button.toggle()
      expect(button.toggle()).toEqual true

    it 'toggles the button to a selected state', ->
      button.canToggle true
      button.toggle()
      expect(button.selected()).toEqual true

    it 'toggles the button to a non-selected state', ->
      button.canToggle true
      button.toggle()
      button.toggle()
      expect(button.selected()).toEqual false


  describe 'handleStateChanged (overridable method)', ->
    beforeEach ->
        spyOn(button, 'handleStateChanged').andCallThrough()
    
    it 'is called on [click]', ->
      button.click()
      expect(button.handleStateChanged).toHaveBeenCalled()

    it 'is called on [mouseover]', ->
      button.el.mouseover()
      expect(button.handleStateChanged).toHaveBeenCalled()

    it 'is called on [mouseout]', ->
      button.el.mouseout()
      expect(button.handleStateChanged).toHaveBeenCalled()
    
    it 'is called on [mousedown]', ->
      button.el.mousedown()
      expect(button.handleStateChanged).toHaveBeenCalled()
    
    it 'is called on [mouseup]', ->
      button.el.mouseup()
      expect(button.handleStateChanged).toHaveBeenCalled()

    it 'is called on [selected] set to true', ->
      button.canToggle true
      button.selected true
      expect(button.handleStateChanged).toHaveBeenCalled()

    it 'is called on [selected] set to false', ->
      button.canToggle true
      button.selected true
      button.selected false
      expect(button.handleStateChanged.callCount).toEqual 2

  describe 'handleSelectedChanged (overridable method)', ->
    args = null
    beforeEach ->
        args = null
        button.canToggle true
        spyOn(button, 'handleSelectedChanged').andCallFake (e) -> args = e
    
    it 'is called on [click]', ->
      button.click()
      expect(button.handleSelectedChanged).toHaveBeenCalled()

    it 'passes args as selected', ->
      button.click()
      expect(args.selected).toEqual true

    it 'passes args as not selected', ->
      button.click()
      button.click()
      expect(args.selected).toEqual false

      
  describe 'CSS classes on state change', ->
    it 'calls [_syncClasses] when state changed', ->
      spyOn button, '_syncClasses'
      button._stateChanged 'mouseover'
      expect(button._syncClasses).toHaveBeenCalled()
    
    describe 'selected class', ->
      beforeEach -> button.canToggle true
      it 'has [core_selected] class (from click)', ->
        button.click()
        expect(button.el.hasClass('core_selected')).toEqual true

      it 'has [core_selected] class (from [selected] property changed)', ->
        button.selected true
        expect(button.el.hasClass('core_selected')).toEqual true
        
      it 'does not have [core_selected] class (from click)', ->
        button.click()
        button.click()
        expect(button.el.hasClass('core_selected')).toEqual false

      it 'does not have [core_selected] class (from [selected] property changed)', ->
        button.selected true
        button.selected false
        expect(button.el.hasClass('core_selected')).toEqual false

    describe 'over class', ->
      it 'has [core_over] class', ->
        button.el.mouseover()
        expect(button.el.hasClass('core_over')).toEqual true
        
      it 'does not have [core_over] class', ->
        button.el.mouseover()
        button.el.mouseout()
        expect(button.el.hasClass('core_over')).toEqual false
    
    describe 'down class', ->
      it 'has [core_down] class', ->
        button.el.mousedown()
        expect(button.el.hasClass('core_down')).toEqual true
        
      it 'does not have [core_down] class', ->
        button.el.mousedown()
        button.el.mouseup()
        expect(button.el.hasClass('core_down')).toEqual false
        



