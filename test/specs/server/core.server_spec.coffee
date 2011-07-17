describe 'server/core.server', ->
  server = require 'core.server'

  it 'exists', ->
    expect(server).toBeDefined()

  it 'exposes the client lib', ->
    expect(server.client).toEqual require('core.client')


