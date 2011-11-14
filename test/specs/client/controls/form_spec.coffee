describe 'controls/form', ->
  formList = null
  beforeEach ->
    formList = new controls.Form()
  
  it 'exists', ->
    expect(controls.Form).toBeDefined()
  
  it 'is an MVC View', ->
    expect(formList instanceof core.mvc.View).toEqual true 
  
  it 'has a CSS class name', ->
    expect(formList.el.hasClass('core_form')).toEqual true
    
    
  
  