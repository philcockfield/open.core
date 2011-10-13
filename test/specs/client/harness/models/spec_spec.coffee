describe 'harness/models/spec', ->
  harness = null
  Spec   = null
  
  beforeEach ->
      harness = new Harness().init('<div></div>')
      Spec = harness.models.Spec
  
  it 'exists', ->
    expect(harness.models.Spec).toBeDefined()
  
  