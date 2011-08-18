describe 'mvc/module', ->
  Module = null
  module = null
  
  beforeEach ->
      Module = core.mvc.Module
      module = new Module()
  
  it 'exists', ->
    expect(Module).toBeDefined()
  
  it 'extends core.Base', ->
    expect(module instanceof core.Base).toEqual true 
  
    
  