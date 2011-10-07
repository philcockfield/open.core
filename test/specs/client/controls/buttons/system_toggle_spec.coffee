describe 'controls/buttons/system_toggle', ->
  SampleButton = null
  SystemToggle  = null
  btn          = null
  
  beforeEach ->
      SystemToggle = require 'open.client/controls/buttons/system_toggle'
      
      class SampleButton extends SystemToggle
        constructor: (params) -> 
            @_cssPrefix = 'custom'
            super params
            @elInput = $ '<INPUT type="radio" />'
            @render()
      btn = new SampleButton()
      
  
  it 'exists', ->
    expect(SystemToggle).toBeDefined()
  
  it 'can toggle by default', ->
    expect(btn.canToggle()).toEqual true

  it 'has a label element', ->
    label = btn.el.find 'span.custom_label'
    expect(label.length).toEqual 1
  
  describe 'css classes', ->
    it 'has the default CSS class', ->
      btn = new SystemToggle()
      expect(btn.el.get(0).className).toEqual 'core_system_toggle_btn'
  
    it 'has custom CSS class', ->
      expect(btn.el.get(0).className).toEqual 'custom_system_toggle_btn'
  
  describe 'checked() control state method', ->
    describe 'reading the INPUT elements checked state', ->
      it 'is checked', ->
        btn.elInput.attr 'checked', true
        expect(btn.checked()).toEqual true
      
      it 'is not checked', ->
        btn.checked true
        btn.elInput.attr 'checked', false
        expect(btn.checked()).toEqual false
    
    describe 'writing the INPUT elements checked state', ->
      it 'is checked', ->
        btn.checked true
        expect(btn.elInput.attr('checked')).toEqual 'checked'
      
      it 'is not checked', ->
        btn.checked true
        btn.checked false
        expect(btn.elInput.attr('checked')).toEqual undefined
    
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
      
      # TEMP 
      # NO LONGER RELEVANT
      # Delete when the button is working from clicks that bubble up and include a srcElement in the args.
      
      # it 'sets selected() to True when INPUT is checked', ->
      #   btn.elInput.attr 'checked', true
      #   expect(btn.selected()).toEqual true
      #   
      # it 'sets selected() to False when INPUT is unchecked', ->
      #   btn.selected true
      #   btn.elInput.attr 'checked', false
      #   expect(btn.selected()).toEqual false
        
      
      
      
    
    




