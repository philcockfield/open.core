describe 'core/mvc/data_binder', ->
  DataBinder = undefined
  beforeEach ->
      DataBinder = core.mvc.DataBinder
  
  it 'exists', ->
    expect(DataBinder).toBeDefined()
  