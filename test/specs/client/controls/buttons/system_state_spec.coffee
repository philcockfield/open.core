describe 'controls/buttons/system_state', ->
  SystemState = null
  btn         = null
  
  beforeEach ->
      SystemState = require 'open.client/controls/buttons/system_state'
      
      class SampleButton extends SystemState
        constructor: (params) -> 
            @_css_prefix = 'custom'
            super params
            @inputEl = $ '<INPUT type="radio" />'
            @render()
      btn = new SampleButton()
      
  
  it 'exists', ->
    expect(SystemState).toBeDefined()
  
  it 'can toggle', ->
    expect(btn.canToggle()).toEqual true

  it 'has a label element', ->
    label = btn.el.find 'span.custom_label'
    expect(label.length).toEqual 1
  
  describe 'css classes', ->
    it 'has the default CSS class', ->
      btn = new SystemState()
      expect(btn.el.get(0).className).toEqual 'core_system_state_btn'
  
    it 'has custom CSS class', ->
      expect(btn.el.get(0).className).toEqual 'custom_system_state_btn'
  
  describe 'checked state', ->
    
  
  
  
  
  
  
  
  
  
  