describe 'client', ->
  it 'exists', ->
    expect(require('core')).toBeDefined()

  it 'has title', ->
    expect(_.isString(core.title)).toEqual true