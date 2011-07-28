describe 'client/mvc/model', ->
  Model = null
  beforeEach ->
    Model = core.mvc.Model

  it 'calls constructor on Base', ->
    ensure.parentConstructorWasCalled Model, -> new Model()

  
