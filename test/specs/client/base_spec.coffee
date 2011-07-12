describe 'client/base', ->
  Base = test.client.Base

  it 'is provided off the root core.client', ->
    expect(test.client.Base).toEqual require "#{test.paths.client}/base"

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



