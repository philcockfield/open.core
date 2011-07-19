describe 'client/base', ->
  Base = null
  beforeEach ->
    Base = core.Base

  it 'supports eventing', ->
    base = new Base()
    expect(-> base.bind('foo')).not.toThrow()

  it 'merges parameters', ->
    class Parent extends Base
      constructor: (@params) ->

    class Child extends Parent
      constructor: (@params) ->
        super @util.merge @params, { bar:456 }

    obj = new Child(foo:123)
    expect(obj.params.foo).toEqual 123
    expect(obj.params.bar).toEqual 456



