describe 'open.server', ->
  server = require 'open.server'

  it 'exists', ->
    expect(server).toBeDefined()

  it 'exposes the client lib', ->
    expect(server.client).toEqual require('open.client')
  
  it 'exists the MVC lib', ->
    expect(server.mvc).toEqual server.client.core.mvc
    
    
  
  

