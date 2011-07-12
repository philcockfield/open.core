describe 'client/core.client', ->
  it 'exposes the MVC index', ->
    expect(test.client.mvc).toEqual require "#{test.paths.client}/mvc"

