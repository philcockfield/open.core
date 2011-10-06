describe 'controls/buttons/rdo (Radio Button)', ->
  RadioButton = null
  rdo         = null
  beforeEach ->
      RadioButton = controls.RadioButton
      rdo = new RadioButton()
  
  it 'exists', ->
    expect(RadioButton).toBeDefined()
  
  it 'is a Button', ->
    expect(rdo instanceof RadioButton).toEqual true 
  
  it 'sets the [elInput] to be a radio button', ->
    expect(rdo.elInput.get(0).tagName.toLowerCase()).toEqual 'input'
    expect(rdo.elInput.attr('type')).toEqual 'radio'

  it 'has the radio-button CSS class', ->
    expect(rdo.el.hasClass('core_radio')).toEqual true
  
  