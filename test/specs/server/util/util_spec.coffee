describe 'server/util', ->
  util = core.util
  
  it 'aliases to client toBool() method', ->
    expect(util.toBool).toEqual core.client.util.toBool


