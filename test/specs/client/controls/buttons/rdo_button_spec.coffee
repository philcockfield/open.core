describe 'controls/buttons/rdo_button', ->
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
  
  