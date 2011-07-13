describe 'server/util/fs', ->
  paths     = test.paths
  fsUtil    = test.server.util.fs

  it 'is available from the util module', ->
    expect(test.server.util.fs).toBeDefined()


  describe 'exists', ->
    it 'determines that a file exists', ->
      path = "#{paths.server}/core.server.coffee"
      exists = null
      fsUtil.exists path, (result) -> exists = result
      waitsFor -> exists?
      runs -> expect(exists).toEqual true

    it 'determines that a folder exists', ->
      path = "#{paths.server}"
      exists = null
      fsUtil.exists path, (result) -> exists = result
      waitsFor -> exists?
      runs -> expect(exists).toEqual true

    it 'determines that a path does not exist', ->
      path = "foo.bar"
      exists = null
      fsUtil.exists path, (result) ->
          exists = result
      waitsFor -> exists?
      runs -> expect(exists).toEqual false






