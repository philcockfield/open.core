describe 'controls/button', ->
  Button = require 'core/controls/button'
  button = null
  beforeEach ->
      button = new Button()
  
  it 'exists', ->
    expect(Button).toBeDefined()

  it 'is an MVC view', ->
    expect(button instanceof core.mvc.View).toEqual true 
  
  
  describe 'default values', ->
    # it 'is not pressed by default', ->
    #   expect(button.isPressed()).toEqual false
    
    # it 'is does not toggle by default', ->
    #   expect(button.canToggle()).toEqual false
    # 
    # it 'is enabled by default', ->
    #   expect(button.isEnabled()).toEqual true
    # 
    # it 'is visible by default', ->
    #   expect(button.isVisible()).toEqual true
    # 
    # it 'has no text label by default', ->
    #   expect(button.label()).toEqual ''
    # 
    # it 'has not type by default', ->
    #   expect(button.type()).toEqual null
    #   