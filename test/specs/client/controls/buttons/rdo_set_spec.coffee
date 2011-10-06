describe 'controls/buttons/rdo_set', ->
  RadioButtonSet = null
  radioSet       = null
  beforeEach ->
      RadioButtonSet = controls.RadioButtonSet
      radioSet = new RadioButtonSet()
  
  it 'exists', ->
    expect(RadioButtonSet).toBeDefined()

  it 'is a [ControlList]', ->
    expect(radioSet instanceof controls.SystemToggleSet).toEqual true 

  it 'has a CSS class', ->
    expect(radioSet.el.hasClass('core_radio_set')).toEqual true
