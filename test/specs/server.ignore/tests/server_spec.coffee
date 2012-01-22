describe 'open.server', ->
  server = require 'open.core/open.server'

  it 'exists', ->
    expect(server).toBeDefined()

  it 'exposes the client lib', ->
    expect(server.client).toEqual require('open.client')


