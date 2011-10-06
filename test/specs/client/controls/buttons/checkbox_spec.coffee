describe 'controls/buttons/checkbox', ->
  Checkbox = null
  chk         = null
  beforeEach ->
      Checkbox = controls.Checkbox
      chk = new Checkbox()
  
  it 'exists', ->
    expect(Checkbox).toBeDefined()
  
  it 'is a Button', ->
    expect(chk instanceof Checkbox).toEqual true 
  
  it 'sets the [elInput] to be a system checkbox', ->
    expect(chk.elInput.get(0).tagName.toLowerCase()).toEqual 'input'
    expect(chk.elInput.attr('type')).toEqual 'checkbox'
  
  
    