describe 'client', ->
  it 'exists', ->
    expect(require('core.client/core')).toBeDefined()

  it 'has title', ->
    expect(_.isString(core.title)).toEqual true
    
