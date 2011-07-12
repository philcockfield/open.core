describe 'client/mvc/view', ->
  core = test.client
  View = core.mvc.View

  it 'is provided', ->
    expect(core.mvc.View).toEqual require "#{test.paths.client}/mvc/view"

