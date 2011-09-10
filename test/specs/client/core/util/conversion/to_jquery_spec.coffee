describe 'util/conversion/to_jquery', ->
  toJQuery = null
  beforeEach -> toJQuery = core.util.toJQuery

  it 'returns the given jQuery object with no change', ->
    body = $('body')
    expect(toJQuery(body)).toEqual body

  it 'finds a CSS selector returning a jQuery object', ->
    expect(toJQuery('body')).toEqual $('body')

  it 'returns the jQuery [el] of a [View] object', ->
    view = new core.mvc.View(className:'foo')
    expect(toJQuery(view)).toEqual view.el

  it 'translates an HTML DOM element to a jQuery object', ->
    elBody = $('body').get(0)
    expect(toJQuery(elBody)).toEqual $(elBody)
  
  it 'throws if value type not supported', ->
    expect(-> toJQuery(12345)).toThrow()

  it 'returns value is not defined', ->
    expect(toJQuery()).toEqual undefined
    expect(toJQuery(undefined)).toEqual undefined
    expect(toJQuery(null)).toEqual null