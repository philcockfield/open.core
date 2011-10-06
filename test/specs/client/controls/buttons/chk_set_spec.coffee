describe 'controls/buttons/chk_set', ->
  CheckboxSet = null
  chkSet     = null
  beforeEach ->
      CheckboxSet = controls.CheckboxSet
      chkSet      = new CheckboxSet()
  
  it 'exists', ->
    expect(CheckboxSet).toBeDefined()

  it 'is a [ControlList]', ->
    expect(chkSet instanceof controls.ControlList).toEqual true 

  it 'has a CSS class', ->
    expect(chkSet.el.hasClass('core_checkbox_set')).toEqual true
