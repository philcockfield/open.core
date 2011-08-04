controls = require 'core/controls'

describe 'controls/button', ->
  Button = controls.Button
  button = null
  beforeEach ->
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
  
    it 'is not pressed by default', ->
      expect(button.pressed()).toEqual false
    
    it 'is does not toggle by default', ->
      expect(button.canToggle()).toEqual false
    
    it 'has no text label by default', ->
      expect(button.label()).toEqual ''


  describe 'constructor', ->
    it 'recieves custom [label] from constructor', ->
      button = new Button(label:'foo')
      expect(button.label()).toEqual 'foo'

    it 'recieves custom [pressed] value from constructor', ->
      button = new Button(pressed: true)
      expect(button.pressed()).toEqual true

    it 'recieves custom [canToggle] value from constructor', ->
      button = new Button(canToggle: true)
      expect(button.canToggle()).toEqual true
      
    
  
    
  describe "click (method and event)", ->
    args = null
    fireCount = null
    beforeEach ->
      button.bind "click", (e) ->
                      args = e
                      fireCount += 1
      
      args = null
      fireCount = 0

    it "fires event when click method is invoked", ->
      button.click()
      expect(fireCount).toEqual 1
    
    it "does not fire event when click method is invoked silently", ->
      button.click silent: true
      expect(fireCount).toEqual 0

    it "does not fire event when the model is disabled", ->
      button.enabled false
      button.click()
      expect(fireCount).toEqual 0
    
    it "returns the model as the event args", ->
      button.click()
      expect(args.source).toEqual button
    
  describe "toggling pressed", ->
    describe "when canToggle is true", ->
      beforeEach ->
        button.canToggle true
      
      it "toggles pressed to true", ->
        button.click()
        expect(button.pressed()).toEqual true
      
      it "toggles pressed to false", ->
        button.click()
        button.click()
        expect(button.pressed()).toEqual false

      it 'does not toggle when disabled', ->
        expect(button.pressed()).toEqual false
        button.enabled false
        button.click()
        expect(button.pressed()).toEqual false
  
    describe "when canToggle is false", ->
      beforeEach ->
        button.canToggle false
      
      it "does not change pressed value", ->
        button.click()
        expect(button.pressed()).toEqual false
    
  describe "onClick : event handler helper", ->
    it "wires up event handler", ->
      onClickCount = 0
      button.onClick ->
        onClickCount += 1
      
      button.click()
      expect(onClickCount).toEqual 1
    
    it "wire up multiple event handlers", ->
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
            button.bind "pre:click", (e) -> preArgs = e
            button.onClick (e)-> clickArgs = e
  
    it 'fires a pre:click event', ->
      button.click()
      expect(preArgs).toBeDefined()
  
    it 'does not fire the click event if the pre:event was cancelled', ->
      button.bind "pre:click", (e) -> e.cancel = true
      button.click()
      expect(clickArgs).not.toBeDefined()
  
    it 'does not toggle if the pre:event was cancelled', ->
      button.bind "pre:click", (e) -> e.cancel = true
      button.canToggle(true);
      button.click()
      expect(button.pressed()).toEqual false
  
  
  describe "[selected] event", ->
    e = undefined
    beforeEach ->
            e = undefined
            button.canToggle true
            button.bind "selected", (args) -> e = args
    
    it "fires selected event when pressed", ->
      button.pressed true
      expect(e.source).toEqual button
    
    it "does not fire selected event when un-pressed", ->
      button.pressed true
      e = null
      button.pressed false
      expect(e).toEqual null
    
    it "does not fire selected event if button does not toggle", ->
      button.canToggle false
      button.pressed true
      expect(e).not.toBeDefined()


  describe "onSelected : event handler helper", ->
    beforeEach ->
        button.canToggle true
    
    it "wires up event handler", ->
      onSelectedCount = 0
      button.onSelected ->
          onSelectedCount += 1
      
      button.click()
      expect(onSelectedCount).toEqual 1
    
    it "wire up multiple event handlers", ->
      fire1 = 0
      fire2 = 0
      button.onSelected ->
        fire1 += 1
      
      button.onClick ->
        fire2 += 1
      
      button.click()
      expect(fire1).toEqual 1
      expect(fire2).toEqual 1  
  
      