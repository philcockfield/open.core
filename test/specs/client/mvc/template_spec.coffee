describe 'client/mvc/template', ->
  core = test.client
  Template = core.mvc.Template

  class Sample extends Template
    foo: """
      Foo: {{ name }}
    """
    bar: -> 'some function'
    baz: 123

  it 'is provided', ->
    expect(core.mvc.Template).toEqual require "#{test.paths.client}/mvc/template"

  it 'converts members into underscore templates', ->
    tmpl = new Sample()
    expect(tmpl.foo instanceof Function).toEqual true

  it 'does not convert non string types to templates', ->
    tmpl = new Sample()
    expect(tmpl.bar()).toEqual 'some function'
    expect(tmpl.baz).toEqual 123







