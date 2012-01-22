describe 'server', ->
  server = test.server
  
  
  it 'exists', ->
    expect(server).toBeDefined()
  
  it 'exposes the client lib', ->
    client = require "#{process.env.PWD}/lib/src/open.client"
    expect(server.client).toEqual client




