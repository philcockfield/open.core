describe 'server/util', ->
  util = core.util
  
  it 'aliases to client toBool() method', ->
    expect(util.toBool).toEqual core.client.util.toBool

  it 'puts color in the global namespace', ->
    expect(color).toBeDefined()
  
    
  it 'copies methods from common', ->
    common = require "#{core.paths.server}/util/common"
    for key of common
      commonFn = common[key]
      utilFn = util[key]
      expect(commonFn).toEqual utilFn
      
      
