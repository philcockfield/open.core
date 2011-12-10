describe 'util/package/private_package', ->
  PrivatePackage = null
  beforeEach ->
    PrivatePackage = core.util.PrivatePackage
  
  it 'exists', ->
    expect(PrivatePackage).toBeDefined()
  
  