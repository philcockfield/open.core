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

  it 'overrides the template engine', ->
    fn = -> 
    class CustomEngine extends Template
      root: "<div>Foo</div>"
      toTemplate: -> fn
    
    tmpl = new CustomEngine()
    expect(tmpl.root).toEqual fn

  describe 'passing property values to the constructor', ->
    it 'adds a parameter as a property of the template', ->
      tmpl = new Sample myProp:123
      expect(tmpl.myProp).toEqual 123
    
    it 'does not overwrite an existing property', ->
      tmpl = new Sample foo:123
      expect(tmpl.foo).not.toEqual 123
      expect(tmpl.foo instanceof Function).toEqual true
      
    
    