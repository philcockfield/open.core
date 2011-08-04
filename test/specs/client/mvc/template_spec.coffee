describe 'mvc/template', ->
  Template = null
  Sample = null
  beforeEach ->
    Template = core.mvc.Template
    class Sample extends Template
      foo: """
        Foo: {{ name }}
      """
      bar: -> 'some function'
      baz: 123

  it 'converts members into underscore templates', ->
    tmpl = new Sample()
    expect(tmpl.foo instanceof Function).toEqual true

  it 'does not convert non string types to templates', ->
    tmpl = new Sample()
    expect(tmpl.bar()).toEqual 'some function'
    expect(tmpl.baz).toEqual 123
