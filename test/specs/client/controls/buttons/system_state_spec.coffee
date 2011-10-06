describe 'controls/buttons/system_state', ->
  SampleButton = null
  SystemState  = null
  btn          = null
  
  beforeEach ->
      SystemState = require 'open.client/controls/buttons/system_state'
      
      class SampleButton extends SystemState
        constructor: (params) -> 
            @_css_prefix = 'custom'
            super params
            @elInput = $ '<INPUT type="radio" />'
            @render()
      btn = new SampleButton()
      
  
  it 'exists', ->
    expect(SystemState).toBeDefined()
  
  it 'can toggle by default', ->
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
    describe 'state upon construction', ->
      describe 'default (not selected)', ->
        it 'is not selected upon construction', ->
          expect(btn.selected()).toEqual false
        
        it 'has the INPUT element in a unchecked state at construction', ->
          expect(btn.elInput.attr('checked')).toEqual undefined
      
      describe 'selected:true passed to constructor', ->
        it 'is selected upon construction', ->
          btn = new SampleButton selected:true
          expect(btn.selected()).toEqual true
      
        it 'has the INPUT element in a checked state at construction', ->
          btn = new SampleButton selected:true
          expect(btn.elInput.attr('checked')).toEqual 'checked'
    
    describe 'changing the [selected] property', ->
      it 'sets the checked state on the INPUT', ->
        btn.selected true
        expect(btn.elInput.attr('checked')).toEqual 'checked'
        
      it 'removes the checked state on the INPUT', ->
        btn.selected true
        btn.selected false
        expect(btn.elInput.attr('checked')).toEqual undefined
      
    
    




